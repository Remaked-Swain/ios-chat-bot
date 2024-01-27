import Foundation

struct ResponseModel: Decodable {
    let id, object: String
    let created: Int
    let model, systemFingerprint: String?
    let choices: [Choice]
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case id, object, created, model
        case systemFingerprint = "system_fingerprint"
        case choices, usage
    }
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: Role
    let content: String
    let date: Date
    
    init(role: Role, content: String, date: Date = Date()) {
        self.role = role
        self.content = content
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.role = try container.decode(Role.self, forKey: .role)
        self.content = try container.decode(String.self, forKey: .content)
        self.date = Date()
    }
    
    enum CodingKeys: CodingKey {
        case role
        case content
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.role, forKey: .role)
        try container.encode(self.content, forKey: .content)
    }
}


enum Role: String, Codable {
    case system = "system"
    case user = "user"
    case assistant = "assistant"
}

struct Usage: Decodable {
    let promptTokens, completionTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
