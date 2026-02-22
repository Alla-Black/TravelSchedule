import Foundation
import Combine

final class RouteSelectionModel: ObservableObject {
    @Published var from: Selection?
    @Published var to: Selection?

    var isRouteComplete: Bool {
        from != nil && to != nil
    }
    
    func swap() {
        (from, to) = (to, from)
    }
    
}
