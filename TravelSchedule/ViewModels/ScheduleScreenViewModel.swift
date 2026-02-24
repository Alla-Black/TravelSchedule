import Foundation
import Combine

final class ScheduleScreenViewModel: ObservableObject {
    private let repository: ScheduleRepository
    private let from: Station
    private let to: Station
    private let date: Date
    private let transfers: Bool
    
    @Published private(set) var schedule: [ScheduleCardItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorState: AppErrorState? = nil
    @Published private(set) var filters: ScheduleFilters = .default
    @Published private(set) var displayedSchedule: [ScheduleCardItem] = []
    
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
    
    @MainActor
    func load() async {
        if isLoading { return }
        if !schedule.isEmpty { return }
        
        isLoading = true
        errorState = nil
        
        defer {
            isLoading = false
        }
        
        do {
            schedule = try await repository.fetchSchedule(
                from: from,
                to: to,
                date: date,
                transfers: transfers
            )
            
            rebuildDisplayedSchedule()
            
        } catch {
            if let repoError = error as? RepositoryError {
                
                switch repoError {
                case .noInternet:
                    errorState = .noInternet
                    displayedSchedule = []
                case .server:
                    errorState = .server
                    displayedSchedule = []
                case .dataNotFound:
                    schedule = []
                    displayedSchedule = []
                    errorState = nil
                }
            } else {
                errorState = .server
                displayedSchedule = []
            }
        }
    }

    // MARK: - Filtering
    
    @MainActor
    func applyFilters(_ newFilters: ScheduleFilters) {
        filters = newFilters
        rebuildDisplayedSchedule()
    }
    
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
    
    //MARK: - Helper
    
    // Перевод строки в число для сравнения с выбранным диапазоном
    private func departureHour(from timeTitle: String) -> Int? {
        let parts = timeTitle.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]) else { return nil }
        return hour
    }
}
