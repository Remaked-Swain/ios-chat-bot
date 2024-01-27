import CoreData

final class CoreDataManager: CoreDataManagable {
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load container")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print(error, error.userInfo)
        }
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] where T : NSFetchRequestResult {
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
}
