import Foundation

protocol JSONDecodable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
