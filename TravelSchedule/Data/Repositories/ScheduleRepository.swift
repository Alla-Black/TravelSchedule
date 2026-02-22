import Foundation

protocol ScheduleRepository {
    func fetchSchedule(from: Station, to: Station, date: Date, transfers: Bool) async throws -> [ScheduleCardItem]
}
