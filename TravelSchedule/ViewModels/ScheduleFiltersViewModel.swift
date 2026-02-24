import Foundation
import Combine

final class ScheduleFiltersViewModel: ObservableObject {
    @Published var filters: ScheduleFilters
    
    var isApplyEnabled: Bool {
        filters != .default
    }
    
    init(filters: ScheduleFilters = .default) {
        self.filters = filters
    }
    
    func toggle(_ range: DepartureTimeRange) {
        if filters.departureTimeRanges.contains(range) {
            filters.departureTimeRanges.remove(range)
        } else {
            filters.departureTimeRanges.insert(range)
        }
    }
    
    func setTransfers(_ option: TransfersOption) {
        filters.transfers = option
    }
}
