import OpenAPIRuntime

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadStationsServiceProtocol {
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse
}

final class ThreadStationsService: ThreadStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String = AppConfiguration.apiKey) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid
        ))
        return try response.ok.body.json
    }
}
