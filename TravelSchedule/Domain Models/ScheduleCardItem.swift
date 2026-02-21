import Foundation

struct ScheduleCardItem: Identifiable, Hashable {
    let id: String
    
    let carrierTitle: String
    let carrierLogoURL: URL?
    
    let dateTitle: String
    let departureTimeTitle: String
    let arrivalTimeTitle: String
    let durationTitle: String
    
    let hasTransfers: Bool
    
    var transfersSubtitle: String? {
        hasTransfers ? "С пересадкой" : nil
    }
    
    init(
        uid: String,
        departureRawString: String,
        carrierTitle: String,
        carrierLogoURL: URL?,
        dateTitle: String,
        departureTimeTitle: String,
        arrivalTimeTitle: String,
        durationTitle: String,
        hasTransfers: Bool
    ) {
        self.id = "\(uid)_\(departureRawString)"
        
        self.carrierTitle = carrierTitle
        self.carrierLogoURL = carrierLogoURL
        
        self.dateTitle = dateTitle
        self.departureTimeTitle = departureTimeTitle
        self.arrivalTimeTitle = arrivalTimeTitle
        self.durationTitle = durationTitle
        
        self.hasTransfers = hasTransfers
    }
}
