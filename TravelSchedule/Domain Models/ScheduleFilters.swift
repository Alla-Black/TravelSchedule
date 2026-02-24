import Foundation

struct ScheduleFilters: Equatable {
    var departureTimeRanges: Set<DepartureTimeRange>
    var transfers: TransfersOption
    
    static let `default` = ScheduleFilters(
        departureTimeRanges: [],
        transfers: .all
    )
}

enum DepartureTimeRange: CaseIterable, Hashable {
    case morning
    case day
    case evening
    case night
    
    var title: String {
        switch self {
        case .morning: return "Утро 06:00 – 12:00"
        case .day: return "День 12:00 – 18:00"
        case .evening: return "Вечер 18:00 – 00:00"
        case .night: return "Ночь 00:00 – 06:00"
        }
    }
}

enum TransfersOption: Equatable {
    case all
    case onlyWith
    case onlyDirect
}
