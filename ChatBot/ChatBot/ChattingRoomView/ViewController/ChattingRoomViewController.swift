import UIKit

final class ChattingRoomViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Namespace
    private enum Constants {
        static let buttonImageName: String = "paperplane.fill"
        static let defaultMargin: CGFloat = 6
        static let messageTextViewWidthRatio: CGFloat = 8
        static let messageTextViewHeightRatio: CGFloat = 1/6
        static let messageTextViewHeight: CGFloat = 120
    }
    
    // MARK: View Components
    private lazy var chattingRoomView: UICollectionView = {
        let chattingRoomView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        chattingRoomView.allowsSelection = false
        chattingRoomView.keyboardDismissMode = .onDrag
        return chattingRoomView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView(frame: view.bounds)
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return textView
    }()
    
    private lazy var messageSendButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: Constants.buttonImageName)
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(touchUpMessageSendButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isEnabled = false
        return button
    }()
    
    // MARK: Properties
    private var dataSource: DataSource? = nil
    private var snapshot: Snapshot = Snapshot()
    private var messages: [Message]? = nil
    
    // MARK: Dependencies
    private let networkManager: NetworkRequestable
    
    init(networkManager: NetworkRequestable, messages: [Message]?) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        self.messages = messages
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 구현되지 않음.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        configureDataSource()
        configureDelegate()
    }
}

// MARK: TextView Delegate Methods
extension ChattingRoomViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = Constants.messageTextViewHeight
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let _ = textView.layoutManager.usedRect(for: textView.textContainer)
        
        if let messagesCount = messages?.count {
            scrollToBottom(itemsCount: messagesCount, sectionsCount: dataSource?.numberOfSections(in: chattingRoomView) ?? Section.allCases.count)
        }

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = min(estimatedSize.height, maxHeight)
            }
        }
        textView.isScrollEnabled = estimatedSize.height > maxHeight
        
        hasWhitespacesAndNewlines(textView.text)
    }
}

// MARK: Private Methods
extension ChattingRoomViewController {
    @objc private func touchUpMessageSendButton() {
        messageTextView.isScrollEnabled = false
        messageSendButton.isEnabled = false
        messageTextView.isEditable = false
        
        guard messageTextView.hasText == true,
              let text = messageTextView.text
        else { return }
        
        submitMessage(role: .user, text: text)
        submitMessage(role: .assistant, text: String())
        sendMessageToGPT()
        messageTextView.text = String()
    }
    
    private func submitMessage(role: Role, text: String) {
        let message = Message(role: role, content: text)
        appendItemToDataSource(with: message)
    }
    
    private func initializeBuilder(to gptModel: GPTModel) -> NetworkRequestBuilderProtocol {
        let messages = snapshot.itemIdentifiers.map { $0.message }
        let requestModel = RequestModel(model: gptModel, messages: messages[0..<messages.count - 1].map{$0}, stream: false)
        let endpoint = EndpointType.chatCompletion(apiKey: Bundle.main.APIKey)
        var builder: NetworkRequestBuilderProtocol = NetworkRequestBuilder(jsonEncodeManager: JSONEncodeManager(), endpoint: endpoint)
        builder.setHttpHeaderFields(httpHeaderFields: endpoint.header)
        builder.setHttpMethod(httpMethod: .post)
        builder.setRequestModel(requestModel: requestModel)
        return builder
    }
    
    private func sendMessageToGPT() {
        let builder = initializeBuilder(to: .gpt_3_5_turbo)
        do {
            let request = try builder.build()
            Task {
                do {
                    let responseModel = try await networkManager.request(urlRequest: request)
                    guard let newMessage = responseModel.choices.first?.message else { return }
                    reconfigureCurrentDataSource(with: newMessage)
                } catch {
                    guard let error = error as? NetworkManager.NetworkError else { return }
                    reconfigureCurrentDataSource(with: Message(role: .assistant, content: error.debugDescription))
                }
            }
        } catch {
            guard let error = error as? NetworkRequestBuilder.NetworkBuilderError else { return }
            reconfigureCurrentDataSource(with: Message(role: .assistant, content: error.debugDescription))
        }
    }
    
    private func hasWhitespacesAndNewlines(_ content: String) {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        messageSendButton.isEnabled = trimmedContent.isEmpty ? false : true
    }
}

// MARK: ChattingRoomView Configuration Methods
extension ChattingRoomViewController {
    private func configureHierarchy() {
        view.addSubviews(chattingRoomView, messageTextView, messageSendButton)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MessageCell, Message> { (cell, indexPath, item) in
            cell.message = item
        }
        
        dataSource = DataSource(collectionView: chattingRoomView) { (chattingRoomView, indexPath, itemIdentifier) -> MessageCell? in
            let cell = chattingRoomView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.message)
            return cell
        }
        
        initializeDataSource(with: messages ?? [])
    }
    
    private func configureDelegate() {
        messageTextView.delegate = self
    }
}

// MARK: DataSource Controls
extension ChattingRoomViewController {
    private enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let id: String
        let message: Message
        
        init(id: String = UUID().uuidString, message: Message) {
            self.id = id
            self.message = message
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ChattingRoomViewController.Item, rhs: ChattingRoomViewController.Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    private func initializeDataSource(with messages: [Message?]) {
        let items: [Item] = messages.compactMap { message in
            guard let message = message else { return nil }
            return Item(message: message)
        }
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        scrollToBottom(itemsCount: snapshot.numberOfItems, sectionsCount: snapshot.numberOfSections)
    }
    
    private func appendItemToDataSource(with message: Message) {
        let item = Item(message: message)
        
        snapshot.appendItems([item])
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        scrollToBottom(itemsCount: snapshot.numberOfItems, sectionsCount: snapshot.numberOfSections)
    }
    
    private func reconfigureCurrentDataSource(with message: Message) {
        guard let lastItem = snapshot.itemIdentifiers.last else { return }
        let newItem = Item(message: message)
        snapshot.deleteItems([lastItem])
        snapshot.appendItems([newItem])
        dataSource?.apply(snapshot, animatingDifferences: true)
        messageTextView.isEditable = true
    }
    
    private func scrollToBottom(itemsCount: Int, sectionsCount: Int, at position: UICollectionView.ScrollPosition = .bottom) {
        guard itemsCount > 0,
              sectionsCount > 0
        else { return }
        chattingRoomView.scrollToItem(at: IndexPath(item: itemsCount - 1, section: sectionsCount - 1), at: position, animated: true)
    }
}

// MARK: Autolayout Methods
extension ChattingRoomViewController {
    private func configureConstraints() {
        let layoutMargin = Constants.defaultMargin
        let messageTextViewHeightRatio = Constants.messageTextViewHeightRatio
        let messageTextViewWidthRatio = Constants.messageTextViewWidthRatio
        
        NSLayoutConstraint.activate([
            chattingRoomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomView.bottomAnchor.constraint(equalTo: messageTextView.topAnchor),
            chattingRoomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            chattingRoomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin)
        ])
        
        NSLayoutConstraint.activate([
            messageTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            messageTextView.trailingAnchor.constraint(equalTo: messageSendButton.leadingAnchor),
            messageTextView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: messageTextViewHeightRatio),
            messageTextView.widthAnchor.constraint(equalTo: messageSendButton.widthAnchor, multiplier: messageTextViewWidthRatio)
        ])
        
        NSLayoutConstraint.activate([
            messageSendButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin),
            messageSendButton.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor)
        ])
    }
}
