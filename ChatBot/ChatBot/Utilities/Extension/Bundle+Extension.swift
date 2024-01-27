import Foundation

extension Bundle {
    // MARK: Namespace
    enum APIError: Error, CustomDebugStringConvertible {
        case noExistedAPIPlist
        case noExistedAPIKey
        
        var debugDescription: String {
            switch self {
            case .noExistedAPIPlist: "noExistedAPIPlist"
            case .noExistedAPIKey: "noExistedAPIKey"
            }
        }
    }
    
    // MARK: Public Propreties
    var APIKey: String {
        switch checkAPIKey() {
        case .success(let APIKey):
            return APIKey
        case .failure(let error):
            print(error)
            return error.localizedDescription
        }
    }
}

extension Bundle {
    // MARK: Private methods
    private func checkAPIKey() -> Result<String, APIError> {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            return .failure(.noExistedAPIPlist)
        }
        
        if let plist = NSDictionary(contentsOfFile: filePath),
           let value = plist.object(forKey: "OPENAI_API_KEY") as? String {
            return .success(value)
        } else {
            return .failure(.noExistedAPIKey)
        }
    }
}
