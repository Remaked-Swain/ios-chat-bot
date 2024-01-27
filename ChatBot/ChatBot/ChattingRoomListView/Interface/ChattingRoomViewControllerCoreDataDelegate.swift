protocol ChattingRoomViewControllerCoreDataDelegate: AnyObject {
    func appendDataSource(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel)
    func create(chattingRoomModel: ChattingRoomModel)
    func update(chattingRoomModel: ChattingRoomModel)
}
