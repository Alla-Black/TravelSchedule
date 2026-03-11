import Foundation
import Combine

@MainActor
final class CityPickerViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var cities: [City] = []
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var popularCities: [City] = []
    @Published private(set) var state: LoadState = .idle
    @Published var query: String = ""
    
    // MARK: - Computed properties
    
    var displayedCities: [City] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines) // убираем пробелы и переносы строк, чтобы строка считалась пустой
        return trimmedQuery.isEmpty ? popularCities : filteredCities
    }
    
    // MARK: - Dependencies
    
    private let repository: StationsRepository
    
    // MARK: - Private Properties
    
    private let popularCityTitles: [String] = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск",
        "Екатеринбург",
        "Новосибирск",
        "Нижний Новгород"
    ]
    
    // MARK: - Initializers
    
    init(repository: StationsRepository) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func load() async {
        if case .loading = state { return }
        
        if !cities.isEmpty {
            updatePopularCitiesFromLoadedReference()
            applyFilter()
            state = .loaded
            return
        }
        
        state = .loading
        
        do {
            cities = try await repository.getCities()
            updatePopularCitiesFromLoadedReference()
            applyFilter()
            state = .loaded
        } catch {
            state = .error(mapError(error))
        }
    }
    
    func applyFilter() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter {
                $0.title.localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updatePopularCitiesFromLoadedReference() {
        guard !cities.isEmpty else {
            popularCities = []
            return
        }
        
        var resolved: [City] = []
        resolved.reserveCapacity(popularCityTitles.count)
        
        for title in popularCityTitles {
            if let match = cities.first(where: { $0.title == title }) {
                resolved.append(match)
            }
        }
        
        popularCities = resolved.isEmpty ? Array(cities.prefix(10)) : resolved
    }
    
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
