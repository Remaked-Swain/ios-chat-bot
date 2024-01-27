import Foundation

extension ChattingRoomEntity {
    func toDTO() -> ChattingRoomModel {
        let id = self.id ?? ""
        let title = self.title ?? ""
        let date = self.date ?? Date.now
        return ChattingRoomModel(id: id, title: title, date: date, messages: [])
    }
}

extension MessageEntity {
    func toDTO() -> Message {
        let role = Role(rawValue: self.role ?? "") ?? .user
        let content = self.content ?? ""
        return Message(role: role, content: content)
    }
}
