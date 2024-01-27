struct RequestModel: Encodable {
    let model: GPTModel
    let messages: [Message]
    let stream: Bool?
}
