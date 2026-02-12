import OpenAPIRuntime
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String = AppConfiguration.apiKey) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(query: .init(
            apikey: apikey
        ))
        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024 // 50Mb
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
        
        return allStations
    }
}
