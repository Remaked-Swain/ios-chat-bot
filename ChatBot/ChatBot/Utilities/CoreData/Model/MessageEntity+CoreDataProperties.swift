//
//  MessageEntity+CoreDataProperties.swift
//  ChatBot
//
//  Created by Swain Yun on 1/22/24.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var role: String?
    @NSManaged public var content: String?
    @NSManaged public var chattingRoomRelationship: ChattingRoomEntity?

}

extension MessageEntity : Identifiable {

}
