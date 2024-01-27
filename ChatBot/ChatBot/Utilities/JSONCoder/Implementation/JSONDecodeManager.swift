import Foundation

struct JSONDecodeManager: JSONDecodable {
    // MARK: Private Properties
    private let decoder: JSONDecodable
    
    // MARK: Life Cycle
    init(decoder: JSONDecodable = JSONDecoder()) {
        self.decoder = decoder
    }
    
    // MARK: Public Methods
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            let decodedModel = try decoder.decode(type, from: data)
            return decodedModel
        } catch {
            guard let error = error as? DecodingError else {
                throw error
            }
            throw error
        }
    }
}
