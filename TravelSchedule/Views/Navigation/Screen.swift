import Foundation

enum Screen: Hashable {
    case city(Direction)
    case station(Direction, City)
}
