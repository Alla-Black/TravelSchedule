import Foundation
import Combine

final class ScheduleScreenViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var schedule: [ScheduleCardItem] = []
    @Published private(set) var displayedSchedule: [ScheduleCardItem] = []
    @Published private(set) var filters: ScheduleFilters = .default
    @Published private(set) var state: LoadState = .idle
    
    // MARK: - Computed properties
    
    var hasActiveFilters: Bool {
        filters != .default
    }
    
    // MARK: - Dependencies
    
    private let repository: ScheduleRepository
    
    // MARK: - Private Properties
    
    private let from: Station
    private let to: Station
    private let date: Date
    private let transfers: Bool
    
    // MARK: - Initializers
    
    init(
        repository: ScheduleRepository,
        from: Station,
        to: Station,
        date: Date = Date(),
        transfers: Bool = true
    ) {
        self.repository = repository
        self.from = from
        self.to = to
        self.date = date
        self.transfers = transfers
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func load() async {
        if case .loading = state { return }
        
        if !schedule.isEmpty {
            rebuildDisplayedSchedule()
            state = .loaded
            return
        }
        
        state = .loading
        
        do {
            schedule = try await repository.fetchSchedule(
                from: from,
                to: to,
                date: date,
                transfers: transfers
            )
            
            rebuildDisplayedSchedule()
            state = .loaded
            
        } catch {
            if let repoError = error as? RepositoryError, repoError == .dataNotFound {
                schedule = []
                displayedSchedule = []
                state = .loaded
                return
            }
            
            displayedSchedule = []
            state = .error(mapError(error))
        }
    }
    
    // MARK: - Filtering
    
    @MainActor
    func applyFilters(_ newFilters: ScheduleFilters) {
        filters = newFilters
        rebuildDisplayedSchedule()
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func rebuildDisplayedSchedule() {
        var result = schedule
        
        // 1) Фильтр по пересадкам
        switch filters.transfers {
        case .all:
            break
        case .onlyDirect:
            result = result.filter { !$0.hasTransfers }
        }
        
        // 2) Фильтр по времени отправления
        if !filters.departureTimeRanges.isEmpty {
            result = result.filter { item in
                guard let hour = departureHour(from: item.departureTimeTitle) else { return false }
                return filters.departureTimeRanges.contains { $0.contains(hour: hour) }
            }
        }
        
        displayedSchedule = result
    }
    
    private func mapError(_ error: Error) -> AppErrorState {
        guard let repoError = error as? RepositoryError else { return .server }
        
        switch repoError {
        case .noInternet:
            return .noInternet
        case .server, .dataNotFound:
            return .server
        }
    }
    
    // MARK: - Helper
    
    /// Перевод строки в число для сравнения с выбранным диапазоном
    private func departureHour(from timeTitle: String) -> Int? {
        let parts = timeTitle.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]) else { return nil }
        return hour
    }
}
