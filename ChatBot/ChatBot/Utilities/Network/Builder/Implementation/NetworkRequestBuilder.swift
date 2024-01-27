import Foundation

struct NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    // MARK: Namespace
    enum NetworkBuilderError: Error, CustomDebugStringConvertible {
        case buildRequestFailed
        
        var debugDescription: String {
            switch self {
            case .buildRequestFailed: "빌드 요청 실패"
            }
        }
    }
    
    // MARK: Dependencies
    private let jsonEncodeManager: JSONEncodable
    
    // MARK: Private Properties
    var baseURLString: String
    var requestModel: Encodable? = nil
    var httpMethod: HTTPMethodType = .get
    var httpHeaderFields: [String : String] = [:]
    
    // MARK: Life Cycle
    init(jsonEncodeManager: JSONEncodable, endpoint: EndpointType) {
        self.jsonEncodeManager = jsonEncodeManager
        self.httpHeaderFields = endpoint.header
        self.baseURLString = endpoint.baseURLString
    }
    
    func build() throws -> URLRequest {
        guard let url = URL(string: (baseURLString)),
              let requestModel = requestModel
        else {
            throw NetworkBuilderError.buildRequestFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeaderFields
        request.httpBody = try jsonEncodeManager.encode(requestModel)
        
        return request
    }
}
