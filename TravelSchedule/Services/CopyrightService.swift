import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apiKey = apikey
    }
    
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(apikey: apiKey)
        )
        return try response.ok.body.json
    }
}
