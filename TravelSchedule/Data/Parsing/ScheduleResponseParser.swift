import Foundation

private protocol DateParsingFormatter {
    func date(from string: String) -> Date?
}

extension ISO8601DateFormatter: DateParsingFormatter {}
extension DateFormatter: DateParsingFormatter {}

struct ScheduleResponseParser {
    private enum Constants {
        static let unknownCarrier = "Перевозчик неизвестен"
        static let dash = "—"
        static let localeID = "ru_RU"
        static let dateFormat = "d MMMM"
        static let timeFormat = "HH:mm"
        static let fallbackFormat = "yyyy-MM-dd HH:mm:ss"
        static let httpsPrefix = "https:"
    }
    
    func parse(dto: Components.Schemas.Segments) -> [ScheduleCardItem] {
        let segments = dto.segments ?? []
        return segments.compactMap(mapSegment)
    }
    
    // MARK: - Private Mapping
    
    private func mapSegment(_ segment: Components.Schemas.Segment) -> ScheduleCardItem? {
        guard let uid = segment.thread?.uid,
              let departureRaw = segment.departure else {
            return nil
        }
        
        let carrierTitle = segment.thread?.carrier?.title ?? Constants.unknownCarrier
        let carrierLogoURL = makeLogoURL(from: segment.thread?.carrier?.logo)
        
        let dateTitle = formatDate(from: departureRaw)
        let departureTimeTitle = formatTime(from: departureRaw)
        
        let arrivalTimeTitle = computeArrivalTime(
            departureRaw: departureRaw,
            arrivalRaw: segment.arrival,
            durationSeconds: segment.duration
        )
        
        let durationTitle = formatDuration(segment.duration)
        
        let hasTransfers = segment.has_transfers ?? false
        
        return ScheduleCardItem(
            uid: uid,
            departureRawString: departureRaw,
            carrierTitle: carrierTitle,
            carrierLogoURL: carrierLogoURL,
            dateTitle: dateTitle,
            departureTimeTitle: departureTimeTitle,
            arrivalTimeTitle: arrivalTimeTitle,
            durationTitle: durationTitle,
            hasTransfers: hasTransfers
        )
    }
    
    // MARK: - Helpers
    
    private func makeLogoURL(from raw: String?) -> URL? {
        guard var raw = raw, !raw.isEmpty else { return nil }
        if raw.hasPrefix("//") {
            raw = Constants.httpsPrefix + raw
        }
        return URL(string: raw)
    }
    
    private func computeArrivalTime(
        departureRaw: String,
        arrivalRaw: String?,
        durationSeconds: Int?
    ) -> String {
        
        if let arrivalRaw,
           let arrivalDate = parseISO(arrivalRaw) {
            return formatTime(from: arrivalDate)
        }
        
        guard let departureDate = parseISO(departureRaw),
              let durationSeconds,
              durationSeconds > 0 else {
            return Constants.dash
        }
        
        let computedArrival = departureDate.addingTimeInterval(TimeInterval(durationSeconds))
        return formatTime(from: computedArrival)
    }
    
    private func formatDuration(_ seconds: Int?) -> String {
        guard let seconds, seconds > 0 else { return Constants.dash }
        
        let hoursDouble = Double(seconds) / 3600.0
        let roundedHours = max(1, Int(hoursDouble.rounded()))
        
        return "\(roundedHours) \(hoursWordForm(for: roundedHours))"
    }
    
    private func hoursWordForm(for hours: Int) -> String {
        
        // 1, 21, 31... -> "час"
        // 2-4, 22-24... -> "часа"
        // 5-20, 25-30... -> "часов"
        let mod100 = hours % 100
        if (11...14).contains(mod100) {
            return "часов"
        }
        switch hours % 10 {
        case 1:
            return "час"
        case 2, 3, 4:
            return "часа"
        default:
            return "часов"
        }
    }
    
    // MARK: - Date Formatting
    
    private func parseISO(_ raw: String) -> Date? {
        for formatter in Self.isoFormatters {
            if let date = formatter.date(from: raw) {
                return date
            }
        }
        return nil
    }
    
    private func formatDate(from raw: String) -> String {
        guard let date = parseISO(raw) else { return Constants.dash }
        return Self.dateFormatter.string(from: date)
    }
    
    private func formatTime(from raw: String) -> String {
        guard let date = parseISO(raw) else { return Constants.dash }
        return Self.timeFormatter.string(from: date)
    }
    
    private func formatTime(from date: Date) -> String {
        return Self.timeFormatter.string(from: date)
    }
    
    // MARK: - Static Formatters
    
    private static let isoFormatters: [DateParsingFormatter] = [
        isoFormatterWithFractional,
        isoFormatter,
        fallbackFormatter
    ]
    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private static let isoFormatterWithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.localeID)
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.localeID)
        formatter.dateFormat = Constants.timeFormat
        return formatter
    }()
    
    private static let fallbackFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.localeID)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = Constants.fallbackFormat
        return formatter
    }()
}
