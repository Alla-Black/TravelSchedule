import Foundation
import Combine

@MainActor
final class NavigationModel: ObservableObject {
    @Published var path: [Screen] = [] // массив экранов
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
