import Foundation
import OpenAPIURLSession
import OpenAPIRuntime
import os

final class DefaultCarrierInfoRepository: CarrierInfoRepository {
    private enum Constants {
        static let defaultSubsystem = "TravelSchedule"
        static let loggerCategory = "CarrierInfoRepository"
        static let loadCarrierInfoFailed = "Failed to load carrier info: "
        static let error404Token = "statusCode: 404"
    }
    
    // MARK: - Private Properties
    
    private let apikey: String = AppConfiguration.apiKey
    private let parser = CarrierInfoParser()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? Constants.defaultSubsystem,
        category: Constants.loggerCategory
    )
    
    // MARK: - Public Methods
    
    func fetchCarrierInfo(code: String) async throws -> CarrierInfo {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CarrierInfoService(
                client: client,
                apikey: apikey
            )
            
            let dto = try await service.getCarrierInfo(
                code: code,
                system: nil
            )
            guard let parsed = parser.parse(dto: dto) else {
                throw RepositoryError.dataNotFound
            }
            
            return parsed
            
        } catch {
            logger.error("\(Constants.loadCarrierInfoFailed)\(String(describing: error))")
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
