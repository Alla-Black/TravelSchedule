import Foundation

struct Selection: Hashable, Sendable {
    let city: City
    let station: Station
    var displayTitle: String {
        "\(city.title) (\(station.title))"
    }
}
