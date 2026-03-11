import Foundation

enum RepositoryError: Error, Equatable, Sendable {
    case noInternet
    case server
    case dataNotFound
}
