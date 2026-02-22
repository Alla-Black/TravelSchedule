import Foundation
import Combine

final class StationPickerViewModel: ObservableObject {
    private let repository: StationsRepository
    private let city: City
    
    @Published private(set) var stations: [Station] = []
    @Published private(set) var filteredStations: [Station] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorState: AppErrorState? = nil
    @Published var query: String = ""
    
    init(repository: StationsRepository, city: City) {
        self.repository = repository
        self.city = city
    }
    
    @MainActor
    func load() async {
        if isLoading { return }
        if !stations.isEmpty {
            applyFilter()
            return
        }
        
        isLoading = true
        errorState = nil
        
        defer {
            isLoading = false
        }
        
        do {
            stations = try await repository.getStations(cityId: city.id)
            applyFilter()
        } catch {
            if let repoError = error as? RepositoryError {
                switch repoError {
                case .noInternet:
                    errorState = .noInternet
                case .server:
                    errorState = .server
                case .dataNotFound:
                    errorState = .server
                }
            } else {
                errorState = .server
            }
        }
    }
    
    func applyFilter() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty {
            filteredStations = stations
        } else {
            filteredStations = stations.filter {
                $0.title.localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
    }
}
