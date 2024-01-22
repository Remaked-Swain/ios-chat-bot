import CoreData

protocol CoreDataCreatable {
    func create()
}

protocol CoreDataReadable {
    func read()
}

protocol CoreDataUpdatable {
    func update()
}

protocol CoreDataDeletable {
    func delete()
}

protocol CoreDataManagable: CoreDataCreatable & CoreDataReadable & CoreDataUpdatable & CoreDataDeletable {
    var context: NSManagedObjectContext { get }
}
