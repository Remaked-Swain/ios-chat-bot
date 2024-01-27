import Foundation

protocol NetworkRequestable {
    func request(urlRequest: URLRequest) async throws -> ResponseModel
}

final class NetworkManager: NetworkRequestable {
    // MARK: Namespace
    enum NetworkError: Error, CustomDebugStringConvertible {
        case castingError
        case badClientRequest(statusCode: Int)
        case badServerResponse(statusCode: Int)
        case taskingError
        case corruptedData
        
        var debugDescription: String {
            switch self {
            case .castingError: "알 수 없는 에러입니다."
            case .badClientRequest(let statusCode): "클라이언트 측 에러입니다. Code: \(statusCode)"
            case .badServerResponse(let statusCode): "서버 측 에러입니다. Code: \(statusCode)"
            case .taskingError: "DataTask 작업 중 에러가 발생했습니다."
            case .corruptedData: "손상된 데이터입니다."
            }
        }
    }
        
    // MARK: Dependencies
    private let jsonDecodeManager: JSONDecodable

    // MARK: Life Cycle
    init(jsonDecodeManager: JSONDecodable = JSONDecodeManager()) {
        self.jsonDecodeManager = jsonDecodeManager
    }
    
    // MARK: Public Methods
    func request(urlRequest: URLRequest) async throws -> ResponseModel {
        let data = try await downloadData(for: urlRequest)
        let responseModel = try jsonDecodeManager.decode(ResponseModel.self, from: data)
        return responseModel
    }
}

// MARK: Private Methods
extension NetworkManager {
    private func downloadData(for request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.castingError
        }
        
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badServerResponse(statusCode: response.statusCode)
        }
        
        return data
    }
}
