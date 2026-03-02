import Foundation
import OpenAPIURLSession
import OpenAPIRuntime
import os

final class DefaultScheduleRepository: ScheduleRepository {
    private enum Constants {
            static let defaultSubsystem = "TravelSchedule"
            static let loggerCategory = "ScheduleRepository"
            static let apiDateFormat = "yyyy-MM-dd"
            static let posixLocale = "en_US_POSIX"
            static let error404Token = "statusCode: 404"
            static let loadScheduleFailed = "Failed to load schedule between stations: "
        }
    
    // MARK: - Private Properties
    
    private let apikey: String = AppConfiguration.apiKey
    private let parser = ScheduleResponseParser()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? Constants.defaultSubsystem,
        category: Constants.loggerCategory
    )
    
    private var cache: [CacheKey: [ScheduleCardItem]] = [:]
    
    // MARK: - Static Properties
    
    private static let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = Constants.apiDateFormat
        f.locale = Locale(identifier: Constants.posixLocale)
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
            logger.error("\(Constants.loadScheduleFailed)\(String(describing: error))")
            if let repoError = error as? RepositoryError {
                    throw repoError
                }
            
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                throw RepositoryError.noInternet
            }
            let description = String(describing: error)
            if description.contains(Constants.error404Token) {
                throw RepositoryError.dataNotFound
            }
            throw RepositoryError.server
        }
    }
}
