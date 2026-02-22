import Foundation
import Combine

final class CityPickerViewModel: ObservableObject {
    private let repository: StationsRepository
    
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
    
    @Published private(set) var cities: [City] = []
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorState: AppErrorState? = nil
    @Published private(set) var popularCities: [City] = []
    @Published var query: String = ""
    
    var displayedCities: [City] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines) // убираем пробелы и переносы строк, чтобы строка считалась пустой
        return trimmedQuery.isEmpty ? popularCities : filteredCities
    }
    
    init(repository: StationsRepository) {
        self.repository = repository
    }
    
    @MainActor
    func load() async {
        if isLoading { return }
        if !cities.isEmpty {
            updatePopularCitiesFromLoadedReference()
            applyFilter()
            return
        }
        
        isLoading = true
        errorState = nil
        
        defer { // блок кода, который выполнится в самом конце функции при любом исходе
            isLoading = false
        }
        
        do {
            cities = try await repository.getCities()
            updatePopularCitiesFromLoadedReference()
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
}
