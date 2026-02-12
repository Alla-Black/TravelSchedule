import Foundation

enum AppConfiguration {
    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: "Configuration", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let key = plist["API_KEY"] as? String
        else {
            fatalError("API_KEY not found in Configuration.plist")
        }
        
        return key
    }
}
