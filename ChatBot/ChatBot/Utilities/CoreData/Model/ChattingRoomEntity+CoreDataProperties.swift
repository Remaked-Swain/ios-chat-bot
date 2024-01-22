//
//  ChattingRoomEntity+CoreDataProperties.swift
//  ChatBot
//
//  Created by Swain Yun on 1/22/24.
//
//

import Foundation
import CoreData


extension ChattingRoomEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChattingRoomEntity> {
        return NSFetchRequest<ChattingRoomEntity>(entityName: "ChattingRoomEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var messageRelationship: NSSet?

}

// MARK: Generated accessors for messageRelationship
extension ChattingRoomEntity {

    @objc(addMessageRelationshipObject:)
    @NSManaged public func addToMessageRelationship(_ value: MessageEntity)

    @objc(removeMessageRelationshipObject:)
    @NSManaged public func removeFromMessageRelationship(_ value: MessageEntity)

    @objc(addMessageRelationship:)
    @NSManaged public func addToMessageRelationship(_ values: NSSet)

    @objc(removeMessageRelationship:)
    @NSManaged public func removeFromMessageRelationship(_ values: NSSet)

}

extension ChattingRoomEntity : Identifiable {

}
