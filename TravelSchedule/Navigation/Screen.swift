import Foundation

enum Screen: Hashable, Sendable {
    case city(Direction)
    case station(Direction, City)
    case schedule(from: Selection, to: Selection)
    case scheduleFilters
    case carrierInfo(code: String)
}
