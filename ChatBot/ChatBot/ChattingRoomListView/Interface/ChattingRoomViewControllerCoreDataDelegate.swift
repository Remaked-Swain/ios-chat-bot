protocol ChattingRoomViewControllerCoreDataDelegate: AnyObject {
    func appendDataSource(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel)
    func create(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel)
    func update(_ chattingRoomViewController: ChattingRoomViewController, with chattingRoomModel: ChattingRoomModel)
}
