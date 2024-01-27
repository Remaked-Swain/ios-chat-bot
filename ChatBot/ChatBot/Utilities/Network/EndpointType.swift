import Foundation

enum EndpointType {
    case chatCompletion(apiKey: String)

    var baseURLString: String { "https://api.openai.com/v1/chat/completions" }
    
    var header: [String: String] {
        switch self {
        case .chatCompletion(let apiKey):
            [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
            ]
        }
    }
}
