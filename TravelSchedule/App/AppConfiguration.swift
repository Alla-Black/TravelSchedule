import Foundation

enum AppConfigurationError: Error, LocalizedError {
    case missingInfoPlistValue(key: String)
    
    var errorDescription: String? {
        switch self {
        case .missingInfoPlistValue(let key):
            return "Missing or empty '\(key)' in Info.plist"
        }
    }
}

enum AppConfiguration {
    private static let infoPlistKey = "YandexSchedulesAPIKey"
    
    static var apiKey: String {
        guard
            let apiKey = Bundle.main.object(forInfoDictionaryKey: infoPlistKey) as? String,
            !apiKey.isEmpty
        else {
            let error = AppConfigurationError.missingInfoPlistValue(key: infoPlistKey)
            preconditionFailure(error.localizedDescription)
        }
        
        return apiKey
    }
}
