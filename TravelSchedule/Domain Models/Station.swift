import Foundation

struct Station: Hashable, Identifiable, Sendable {
    let id: String
    let title: String
    let stationType: String
}
