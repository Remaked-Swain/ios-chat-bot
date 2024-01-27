import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var role: String?
    @NSManaged public var date: Date?
    @NSManaged public var chattingRoomRelationship: ChattingRoomEntity?

}
