import Foundation
import Combine

@MainActor
final class ScheduleFiltersModel: ObservableObject {
    @Published var filters: ScheduleFilters = .default
}
