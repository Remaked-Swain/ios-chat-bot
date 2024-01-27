import UIKit
import CoreData

protocol ChattingRoomViewControllerCoreDataDelegate: AnyObject {
    func appendDataSource(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel)
    func create(chattingRoomModel: ChattingRoomModel)
    func update(chattingRoomModel: ChattingRoomModel)
}

final class ChattingRoomListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Namespace
    private enum Constants {
        static let buttonImageName: String = "square.and.pencil"
    }
    
    // MARK: View Components
    private lazy var chattingRoomListView: UICollectionView = {
        let chattingRoomListView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        chattingRoomListView.translatesAutoresizingMaskIntoConstraints = false
        chattingRoomListView.delegate = self
        return chattingRoomListView
    }()
    
    // MARK: Properties
    private var dataSource: DataSource?
    private var snapshot: Snapshot = Snapshot()
    private var chattingRoomModels: [ChattingRoomModel]?
    
    // MARK: Dependencies
    private let networkManager: NetworkRequestable
    private let coreDataManager: CoreDataManagable
    
    init(networkManager: NetworkRequestable, coreDataManager: CoreDataManagable) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 구현되지 않음.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        chattingRoomModels = read()
        configureNavigationBar()
        configureHierarchy()
        configureConstraints()
        configureDataSource()
    }
}

// MARK: Private Methods
extension ChattingRoomListViewController {
    @objc private func pushToNewChattingRoomViewController() {
        let newChattingRoomViewController = ChattingRoomViewController(networkManager: networkManager,
                                                                       chattingRoomModel: nil)
        newChattingRoomViewController.delegate = self
        self.navigationController?.pushViewController(newChattingRoomViewController, animated: true)
    }
}

// MARK: DataSource Controls
extension ChattingRoomListViewController {
    private enum Section: CaseIterable {
        case main
    }
    
    private struct Item: Hashable {
        let chattingRoomModel: ChattingRoomModel
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(chattingRoomModel.id)
        }
        
        static func == (lhs: ChattingRoomListViewController.Item, rhs: ChattingRoomListViewController.Item) -> Bool {
            return lhs.chattingRoomModel.id == rhs.chattingRoomModel.id
        }
    }
}

// MARK: ChattingRoomListView Configuration Methods
extension ChattingRoomListViewController: ChattingRoomViewControllerCoreDataDelegate {
    private func configureNavigationBar() {
        let navigationTitle = "MyChatBot"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.buttonImageName), style: .plain, target: self, action: #selector(pushToNewChattingRoomViewController))
        self.navigationItem.title = navigationTitle
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(chattingRoomListView)
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.chattingRoomModel.title
            configuration.secondaryText = itemIdentifier.chattingRoomModel.date.formatted(date: .numeric, time: .complete)
            cell.contentConfiguration = configuration
        }
        
        dataSource = DataSource(collectionView: chattingRoomListView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
     
        initializeDataSource(with: chattingRoomModels ?? [])
    }
    
    private func initializeDataSource(with chattingRoomModels: [ChattingRoomModel]) {
        let items: [Item] = chattingRoomModels.map { chattingRoomModel in
            return Item(chattingRoomModel: chattingRoomModel)
        }
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func appendDataSource(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel) {
        let item: Item = Item(chattingRoomModel: chattingRoomModel)
        
        snapshot.appendItems([item])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: CoreData
extension ChattingRoomListViewController {
    private func read() -> [ChattingRoomModel]? {
        let ChattingRooms = convertToChattingRoomModel()
        return ChattingRooms.map { chattingRoom in
            ChattingRoomModel(id: chattingRoom.id, title: chattingRoom.title, date: chattingRoom.date, messages: convertToMessageModel(id: chattingRoom.id))
        }
    }
    
    private func convertToChattingRoomModel() -> [ChattingRoomModel] {
        let request = ChattingRoomEntity.fetchRequest()
        let chattingRoomEntities = coreDataManager.fetch(request)
        
        return chattingRoomEntities.compactMap { chattingRoomEntity in
            chattingRoomEntity.toDTO()
        }
    }
    
    private func convertToMessageModel(id: String) -> [Message] {
        let messageRequest = MessageEntity.fetchRequest()
        
        messageRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        messageRequest.predicate = NSPredicate(format: "chattingRoomRelationship.id == %@", id)
        
        let messageEntities = self.coreDataManager.fetch(messageRequest)
        
        return messageEntities.compactMap { messageEntity in
            messageEntity.toDTO()
        }
    }
    
    
    func create(chattingRoomModel: ChattingRoomModel) {
        let context = coreDataManager.context
        let chattingRoomEntity = ChattingRoomEntity(context: context)
        
        let messageEntities = chattingRoomModel.messages.map { message in
            let messageEntity = MessageEntity(context: context)
            messageEntity.role = message.role.rawValue
            messageEntity.date = message.date
            messageEntity.content = message.content
            
            return messageEntity
        }
        
        chattingRoomEntity.id = chattingRoomModel.id
        chattingRoomEntity.date = chattingRoomModel.date
        chattingRoomEntity.title = chattingRoomModel.title

        chattingRoomEntity.addToMessageRelationship(NSSet(array: messageEntities))
        
        coreDataManager.save()
    }
    
    func update(chattingRoomModel: ChattingRoomModel) {
        let chattingRoomRequest = ChattingRoomEntity.fetchRequest()
        chattingRoomRequest.predicate = NSPredicate(format: "id == %@", chattingRoomModel.id)
        let chattingRoomEntities = coreDataManager.fetch(chattingRoomRequest)
        guard let chattingRoomEntity = chattingRoomEntities.first else { return }
        
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chattingRoomRelationship.id == %@", chattingRoomModel.id)
        let messageEntities = coreDataManager.fetch(request)
        
        chattingRoomEntity.removeFromMessageRelationship(NSSet(array: messageEntities))
        
        let newMessageEntities = chattingRoomModel.messages.map { message in
            let messageEntity = MessageEntity(context: coreDataManager.context)
            messageEntity.role = message.role.rawValue
            messageEntity.date = message.date
            messageEntity.content = message.content
            
            return messageEntity
        }
        
        chattingRoomEntity.addToMessageRelationship(NSSet(array: newMessageEntities))
        
        coreDataManager.save()
    }
}

// MARK: UICollectionViewDelegate Confirmation
extension ChattingRoomListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chattingRoomModel = snapshot.itemIdentifiers[indexPath.row].chattingRoomModel
        let chattingRoomViewController = ChattingRoomViewController(networkManager: networkManager, chattingRoomModel: chattingRoomModel)
        chattingRoomViewController.delegate = self
        navigationController?.pushViewController(chattingRoomViewController, animated: true)
    }
}

// MARK: Autolayout Methods
extension ChattingRoomListViewController {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            chattingRoomListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chattingRoomListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chattingRoomListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chattingRoomListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
