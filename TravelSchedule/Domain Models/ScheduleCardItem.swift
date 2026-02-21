import Foundation

struct ScheduleCardItem: Identifiable, Hashable {
    let id: String
    
    let carrierTitle: String
    let carrierLogoURL: URL?
    
    let dateTitle: String
    let departureTimeTitle: String
    let arrivalTimeTitle: String
    let durationTitle: String
    
    let transfersTitle: String?
}
