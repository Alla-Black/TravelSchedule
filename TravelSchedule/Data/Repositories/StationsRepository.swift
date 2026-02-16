import Foundation

protocol StationsRepository {
   func getCities() async throws -> [City]
   func getStations(cityId: String) async throws -> [Station]
}
