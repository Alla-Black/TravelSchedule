import Foundation
import Combine

final class RouteSelectionModel: ObservableObject {
    @Published var from: Selection?
    @Published var to: Selection?
}
