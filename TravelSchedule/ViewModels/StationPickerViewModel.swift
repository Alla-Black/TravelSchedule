import Foundation
import Combine

@MainActor
final class StationPickerViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var stations: [Station] = []
    @Published private(set) var filteredStations: [Station] = []
    @Published private(set) var state: LoadState = .idle
    @Published var query: String = ""
    
    // MARK: - Computed properties
    
    private var stationsForDisplay: [Station] {
        let allowed: Set<String> = ["station", "platform", "train_station"]
        
        return stations.filter { station in
            let type = station.stationType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            return !type.isEmpty && allowed.contains(type)
        }
    }
    
    // MARK: - Dependencies
    
    private let repository: StationsRepository
    
    // MARK: - Private Properties
    
    private let city: City
    
    // MARK: - Initializers
    
    init(repository: StationsRepository, city: City) {
        self.repository = repository
        self.city = city
    }
    
    // MARK: - Public Methods
    
    func load() async {
        if case .loading = state { return }
        
        if !stations.isEmpty {
            applyFilter()
            state = .loaded
            return
        }
        
        state = .loading
        
        do {
            stations = try await repository.getStations(cityId: city.id)
            applyFilter()
            state = .loaded
        } catch {
            if let repoError = error as? RepositoryError,
               repoError == .dataNotFound {
                
                stations = []
                filteredStations = []
                state = .loaded
            } else {
                state = .error(mapError(error))
            }
        }
    }
    
    func applyFilter() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = stationsForDisplay
        
        if trimmedQuery.isEmpty {
            filteredStations = base
        } else {
            filteredStations = base.filter {
                $0.title.localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> AppErrorState {
        guard let repoError = error as? RepositoryError else {
            return .server
        }
        
        switch repoError {
        case .noInternet:
            return .noInternet
        case .server, .dataNotFound:
            return .server
        }
    }
}
