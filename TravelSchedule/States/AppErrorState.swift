import SwiftUI

enum AppErrorState: Hashable {
    case server
    case noInternet
    
    var title: String {
        switch self {
        case .server: 
            return "Ошибка сервера"
        case .noInternet: 
            return "Нет интернета"
        }
    }
    
    var imageName: ImageResource {
        switch self {
        case .server:
            return .errorServer
        case .noInternet:
            return .errorNoInternet
        }
    }
}

