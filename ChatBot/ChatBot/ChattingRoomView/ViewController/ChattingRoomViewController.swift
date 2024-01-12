import UIKit

final class ChattingRoomViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Namespace
    enum Constants {
        static let textFieldPlaceholder: String = "문자 메세지"
        static let buttonImageName: String = "arrow.up"
        static let defaultMargin: CGFloat = 6
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let id: String = UUID().uuidString
        let message: Message
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ChattingRoomViewController.Item, rhs: ChattingRoomViewController.Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    // MARK: View Components
    private lazy var chattingRoomView: UICollectionView! = {
        let chattingRoomView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomView.translatesAutoresizingMaskIntoConstraints = false
        chattingRoomView.allowsSelection = false
        return chattingRoomView
    }()
    
    private lazy var bottomStackView: UIStackView! = {
        let padding = Constants.defaultMargin
        let stackView = UIStackView()
        stackView.addArrangedSubviews(textField, messageSendButton)
        stackView.axis = .horizontal
        stackView.spacing = padding
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: padding,
                                               left: padding,
                                               bottom: padding,
                                               right: padding)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textField: UITextField! = {
        let textField = UITextField()
        textField.placeholder = Constants.textFieldPlaceholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var messageSendButton: UIButton! = {
        let button = UIButton()
        let image = UIImage(systemName: Constants.buttonImageName)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Properties
    private var dataSource: DataSource! = nil
    private var messages: [Item]?
    
    init(messages: [Message]) {
        super.init(nibName: nil, bundle: nil)
        self.messages = messages.map({ Item(message: $0) })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureConstraints()
        configureDataSource()
    }
}

// MARK: ChattingRoomView Configuration Methods
extension ChattingRoomViewController {
    private func configureHierarchy() {
        view.addSubviews(chattingRoomView, bottomStackView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MessageCell, Message> { (cell, indexPath, item) in
            let margin = Constants.defaultMargin
            var configuration = cell.defaultContentConfiguration()
            configuration.directionalLayoutMargins = NSDirectionalEdgeInsets(top: margin,
                                                                             leading: margin,
                                                                             bottom: margin,
                                                                             trailing: margin)
            cell.contentConfiguration = configuration
            cell.configureCell(with: item)
        }
        
        dataSource = DataSource(collectionView: chattingRoomView) { (chattingRoomView, indexPath, itemIdentifier) -> UICollectionViewListCell? in
            let cell = chattingRoomView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier.message)
            cell.configureCell(with: itemIdentifier.message)
            return cell
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(messages ?? []) // ToDo: 보다 확실한 Assertion 방지 대책 필요
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Autolayout Methods
extension ChattingRoomViewController {
    private func configureConstraints() {
        let layoutMargin = Constants.defaultMargin
        
        NSLayoutConstraint.activate([
            chattingRoomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor),
            chattingRoomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            chattingRoomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: layoutMargin),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -layoutMargin),
        ])
        
        NSLayoutConstraint.activate([
            messageSendButton.heightAnchor.constraint(equalTo: bottomStackView.heightAnchor),
            messageSendButton.widthAnchor.constraint(equalTo: messageSendButton.heightAnchor)
        ])
    }
}
