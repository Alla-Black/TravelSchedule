import Foundation

final class CarrierInfoParser {
    private enum Constants {
        static let httpsPrefix = "https:"
    }
    
    func parse(dto: CarrierResponse) -> CarrierInfo? {
        guard let carrier = dto.carrier else {
            return nil
        }
        
        let title = carrier.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let title, !title.isEmpty else {
            return nil
        }
        
        return CarrierInfo(
            title: title,
            logoURL: makeLogoURL(from: carrier.logo),
            email: normalizedContactValue(carrier.email),
            phone: normalizedContactValue(carrier.phone)
        )
    }
    
    // MARK: - Helpers
    
    private func normalizedContactValue(_ raw: String?) -> String? {
        guard let value = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return nil
        }
        return value
    }
    
    private func makeLogoURL(from raw: String?) -> URL? {
        guard var raw = raw, !raw.isEmpty else { return nil }
        if raw.hasPrefix("//") {
            raw = Constants.httpsPrefix + raw
        }
        return URL(string: raw)
    }
}
