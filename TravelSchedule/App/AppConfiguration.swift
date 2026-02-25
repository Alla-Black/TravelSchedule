import Foundation

enum AppConfigurationError: Error, LocalizedError {
    case invalidAPIKey(key: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidAPIKey(let key):
            return "Invalid or missing API key in Info.plist for key: \(key). Please set API_KEY in Target → Build Settings → User-Defined."
        }
    }
}

enum AppConfiguration {
    private static let infoPlistKey = "YandexSchedulesAPIKey"
    
    static var apiKey: String {
        do {
            return try loadAPIKey()
        } catch {
            assertionFailure(error.localizedDescription)
            return ""
        }
    }
    
    private static func loadAPIKey() throws -> String {
        guard
            let apiKey = Bundle.main.infoDictionary?[infoPlistKey] as? String,
            !apiKey.isEmpty,
            apiKey != "$(API_KEY)"
        else {
            throw AppConfigurationError.invalidAPIKey(key: infoPlistKey)
        }
        
        return apiKey
    }
}
