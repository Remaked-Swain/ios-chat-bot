import CoreData

protocol CoreDataSaveable {
    func save()
}

protocol CoreDataFetchable {
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] where T : NSFetchRequestResult
}

protocol CoreDataManagable: CoreDataSaveable & CoreDataFetchable {
    var context: NSManagedObjectContext { get }
}
