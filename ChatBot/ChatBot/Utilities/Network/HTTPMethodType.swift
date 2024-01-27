import Foundation

enum HTTPMethodType: CustomStringConvertible {
    case get, post
    
    var description: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        }
    }
}
