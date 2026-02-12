import OpenAPIRuntime

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCityResponse
}

final class NearestCityService: NearestCityServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String = AppConfiguration.apiKey) {
        self.client = client
        self.apikey = apikey
    }
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCityResponse {
        
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try response.ok.body.json
    }
}
