import Foundation

/// Модель карточки рейса для отображения в списке расписания.
/// Содержит уже отформатированные данные, готовые для UI.
struct ScheduleCardItem: Identifiable, Hashable {
    /// Уникальный идентификатор карточки (составной: uid + дата отправления).
    let id: String
    
    /// Название перевозчика (отформатированное для отображения).
    let carrierTitle: String
    
    /// URL логотипа перевозчика.
    let carrierLogoURL: URL?
    
    /// Дата отправления в формате, готовом для UI (например: "12 марта").
    let dateTitle: String
    
    /// Время отправления в формате "HH:mm".
    let departureTimeTitle: String
    
    /// Время прибытия в формате "HH:mm".
    let arrivalTimeTitle: String
    
    /// Отформатированная длительность поездки в целых часах.
    /// (округляется до ближайшего часа, без отображения минут; например: "3 часа").
    let durationTitle: String
    
    /// Признак наличия пересадок.
    let hasTransfers: Bool
    
    /// Подзаголовок для отображения информации о пересадке.
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
