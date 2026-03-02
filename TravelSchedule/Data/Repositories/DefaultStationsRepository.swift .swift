import Foundation
import OpenAPIURLSession
import os

final class DefaultStationsRepository: StationsRepository {
    private enum Constants {
        static let defaultSubsystem = "TravelSchedule"
        static let loggerCategory = "StationsRepository"
        static let loadAllStationsFailed = "Failed to load all stations: "
        static let stationsNotFound = "Stations not found for cityId: "
    }
    
    private let apikey: String = AppConfiguration.apiKey
    private let parser = StationsReferenceParser()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.defaultSubsystem, category: Constants.loggerCategory)
    
    private var cachedCities: [City]?
    private var cachedStationsByCityId: [String: [Station]]?
    
    private func loadIfNeeded() async throws {
        if cachedCities != nil && cachedStationsByCityId != nil {
            return
        }
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = AllStationsService(
                client: client,
                apikey: apikey
            )
            
            let dtoStations = try await service.getAllStations()
            let parsed = parser.parse(allStationResponse: dtoStations)
            
            cachedCities = parsed.citiesById.values.sorted(by: { $0.title < $1.title})
            cachedStationsByCityId = parsed.stationsByCityId
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                logger.error("\(Constants.loadAllStationsFailed)\(String(describing: error))")
                throw RepositoryError.noInternet
            } else {
                logger.error("\(Constants.loadAllStationsFailed)\(String(describing: error))")
                throw RepositoryError.server
            }
        }
    }
    
    func getCities() async throws -> [City] {
        try await loadIfNeeded()
        return cachedCities ?? []
    }
    
    func getStations(cityId: String) async throws -> [Station] {
        try await loadIfNeeded()
        guard let stations = cachedStationsByCityId?[cityId] else {
            logger.error("\(Constants.stationsNotFound) \(cityId)")
            throw RepositoryError.dataNotFound
        }
        return stations.sorted(by: { $0.title < $1.title})
    }
}
