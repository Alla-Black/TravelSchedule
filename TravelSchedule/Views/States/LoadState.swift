import Foundation

enum LoadState {
    case idle
    case loading
    case loaded
    case error(AppErrorState)
}
