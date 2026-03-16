import Foundation

enum LoadState: Sendable {
    case idle
    case loading
    case loaded
    case error(AppErrorState)
}
