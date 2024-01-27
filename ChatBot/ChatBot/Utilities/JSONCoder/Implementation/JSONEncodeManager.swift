import Foundation

struct JSONEncodeManager: JSONEncodable {
    // MARK: Private Properties
    private let encoder: JSONEncodable
    
    // MARK: Life Cycle
    init(encoder: JSONEncodable = JSONEncoder()) {
        self.encoder = encoder
    }

    // MARK: Public Methods
    func encode<T: Encodable>(_ value: T) throws -> Data {
        do {
            let encodedData = try encoder.encode(value)
            return encodedData
        } catch {
            guard let error = error as? EncodingError else {
                throw error
            }
            throw error
        }
    }
}
