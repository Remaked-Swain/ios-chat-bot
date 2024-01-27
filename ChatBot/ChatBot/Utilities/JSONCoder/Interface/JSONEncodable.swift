import Foundation

protocol JSONEncodable {
    func encode<T: Encodable>(_ value: T) throws -> Data
}
