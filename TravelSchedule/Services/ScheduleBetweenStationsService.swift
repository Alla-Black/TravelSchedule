import OpenAPIRuntime

typealias Segments = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String
    ) async throws -> Segments
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String = AppConfiguration.apiKey) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> Segments {
        let response = try await client.getScheduleBetweenStations(
            query: .init(apikey: apikey, from: from, to: to)
        )
        return try response.ok.body.json
    }
}
