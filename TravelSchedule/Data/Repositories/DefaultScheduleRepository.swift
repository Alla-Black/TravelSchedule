import Foundation
import OpenAPIURLSession
import OpenAPIRuntime
import os

final class DefaultScheduleRepository: ScheduleRepository {
    // MARK: - Private Properties
    
    private let apikey: String = AppConfiguration.apiKey
    private let parser = ScheduleResponseParser()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "TravelSchedule",
        category: "ScheduleRepository"
    )
    
    private var cache: [CacheKey: [ScheduleCardItem]] = [:]
    
    // MARK: - Static Properties
    
    private static let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        return f
    }()
    
    // MARK: - Types
    
    private struct CacheKey: Hashable {
        let fromCode: String
        let toCode: String
        let date: String
        let transfers: Bool
    }
    
    // MARK: - Public Methods
    
    func fetchSchedule(from: Station, to: Station, date: Date, transfers: Bool) async throws -> [ScheduleCardItem] {
        let fromCode = from.id
        let toCode = to.id
        let dateString = Self.apiDateFormatter.string(from: date)
        
        let key = CacheKey(fromCode: fromCode, toCode: toCode, date: dateString, transfers: transfers)
        
        if let cached = cache[key] {
            return cached
        }
        
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ScheduleBetweenStationsService(
                client: client,
                apikey: apikey
            )
            
            let dto = try await service.getScheduleBetweenStations(
                from: fromCode,
                to: toCode,
                date: dateString,
                transfers: transfers
            )
            
            let parsed = parser.parse(dto: dto)
            
            if parsed.isEmpty {
                throw RepositoryError.dataNotFound
            }
            
            cache[key] = parsed
            return parsed
            
        } catch {
            logger.error("Failed to load schedule between stations: \(String(describing: error))")
            if let repoError = error as? RepositoryError {
                    throw repoError
                }
            
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                throw RepositoryError.noInternet
            }
            let description = String(describing: error)
            if description.contains("statusCode: 404") {
                throw RepositoryError.dataNotFound
            }
            throw RepositoryError.server
        }
    }
}
