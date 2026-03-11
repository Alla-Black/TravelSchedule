import Foundation
import OpenAPIURLSession
import os

actor DefaultStationsRepository: StationsRepository {
    private enum Constants {
        static let defaultSubsystem = "TravelSchedule"
        static let loggerCategory = "StationsRepository"
        static let loadAllStationsFailed = "Failed to load all stations: "
        static let stationsNotFound = "Stations not found for cityId: "
    }
    
    private let apikey: String
    private let parser: StationsReferenceParser
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.defaultSubsystem, category: Constants.loggerCategory)
    
    private var cachedCities: [City]?
    private var cachedStationsByCityId: [String: [Station]]?
    private var loadingTask: Task<Void, Error>?
    
    init(apikey: String? = nil) {
        self.apikey = apikey ?? AppConfiguration.apiKey
        self.parser = StationsReferenceParser()
    }
    
    private func loadIfNeeded() async throws {
        if cachedCities != nil && cachedStationsByCityId != nil {
            return
        }
        
        if let loadingTask {
            try await loadingTask.value
            return
        }
        
        let task = Task<Void, Error> {
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
                let parsed = self.parser.parse(allStationResponse: dtoStations)
                
                self.updateCache(
                    cities: parsed.citiesById.values.sorted(by: { $0.title < $1.title}),
                    stationsByCityId: parsed.stationsByCityId
                )
            } catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    self.logger.error("\(Constants.loadAllStationsFailed)\(String(describing: error))")
                    throw RepositoryError.noInternet
                } else {
                    self.logger.error("\(Constants.loadAllStationsFailed)\(String(describing: error))")
                    throw RepositoryError.server
                }
            }
        }
        
        loadingTask = task
        
        do {
            try await task.value
            loadingTask = nil
        } catch {
            loadingTask = nil
            throw error
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
    
    private func updateCache(cities: [City], stationsByCityId: [String: [Station]]) {
        cachedCities = cities
        cachedStationsByCityId = stationsByCityId
    }
}
