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
    @Published private(set) var recentCities: [City] = []
    @Published private(set) var popularCities: [City] = []
    @Published var query: String = ""
    
    var displayedCities: [City] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines) // убираем пробелы и переносы строк, чтобы строка считалась пустой
        if trimmedQuery.isEmpty {
            return mergeUnique(primary: recentCities, secondary: popularCities)
        } else {
            return filteredCities
        }
    }
    
    init(repository: StationsRepository) {
        self.repository = repository
    }
    
    @MainActor
    func load() async {
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
            if let repoError = error as? StationsRepositoryError {
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
    
    func select(city: City) {
        recentCities.removeAll { $0.id == city.id }
        recentCities.insert(city, at: 0)
        
        if recentCities.count > 10 {
            recentCities = Array(recentCities.prefix(10))
        }
    }
    
    // MARK: - Helpers
    
    private func mergeUnique(primary: [City], secondary: [City]) -> [City] {
        var seen = Set<String>()
        var result: [City] = []
        result.reserveCapacity(primary.count + secondary.count) // reserveCapacity - заранее выдели память под примерно столько элементов
        
        for city in primary {
            if seen.insert(city.id).inserted { // берем город и пытаемся добавить id в множество. Если добавился, значит он уникальный (ищем дубли)
                result.append(city) // добавляем только уникальные
            }
        }
        
        for city in secondary {
            if seen.insert(city.id).inserted {
                result.append(city)
            }
        }
        return result
    }
    
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
