import Foundation
import Combine

final class CarrierInfoViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var carrierInfo: CarrierInfo?
    @Published private(set) var state: LoadState = .idle
    
    // MARK: - Dependencies
    
    private let repository: CarrierInfoRepository
    private let carrierCode: String
    
    // MARK: - Init
    
    init(
        repository: CarrierInfoRepository,
        carrierCode: String
    ) {
        self.repository = repository
        self.carrierCode = carrierCode
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func load() async {
        if case .loading = state { return }
        
        if carrierInfo != nil {
            state = .loaded
            return
        }
        
        state = .loading
        
        do {
            carrierInfo = try await repository.fetchCarrierInfo(code: carrierCode)
            state = .loaded
        } catch {
            carrierInfo = nil
            state = .error(mapError(error))
        }
    }
    
    // MARK: - Private Methods
    
    private func mapError(_ error: Error) -> AppErrorState {
        guard let repoError = error as? RepositoryError else { return .server }
        
        switch repoError {
        case .noInternet:
            return .noInternet
        case .server, .dataNotFound:
            return .server
        }
    }
}
