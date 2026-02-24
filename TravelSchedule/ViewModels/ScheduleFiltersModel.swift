import Foundation
import Combine

final class ScheduleFiltersModel: ObservableObject {
    @Published var filters: ScheduleFilters = .default
}
