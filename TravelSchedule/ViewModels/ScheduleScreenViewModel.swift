import Foundation
import Combine

final class ScheduleScreenViewModel: ObservableObject {
    private let repository: ScheduleRepository
    private let from: Station
    private let to: Station
    private let date: Date
    private let transfers: Bool
    
    @Published private(set) var schedule: [ScheduleCardItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorState: AppErrorState? = nil
    
    init(
        repository: ScheduleRepository,
        from: Station,
        to: Station,
        date: Date = Date(),
        transfers: Bool = true
    ) {
        self.repository = repository
        self.from = from
        self.to = to
        self.date = date
        self.transfers = transfers
    }
    
    @MainActor
    func load() async {
        if isLoading { return }
        if !schedule.isEmpty { return }
        
        isLoading = true
        errorState = nil
        
        defer {
            isLoading = false
        }
        
        do {
            schedule = try await repository.fetchSchedule(
                from: from,
                to: to,
                date: date,
                transfers: transfers
            )
        } catch {
            if let repoError = error as? RepositoryError {
                
                switch repoError {
                case .noInternet:
                    errorState = .noInternet
                case .server:
                    errorState = .server
                case .dataNotFound:
                    schedule = []
                }
            } else {
                errorState = .server
            }
        }
    }
}
