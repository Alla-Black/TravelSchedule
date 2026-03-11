import Foundation

enum RepositoryError: Error, Equatable {
    case noInternet
    case server
    case dataNotFound
}
