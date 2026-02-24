import Foundation

final class StationsReferenceParser {
    
    func parse(allStationResponse: AllStationsResponse) -> (citiesById: [String: City], stationsByCityId: [String: [Station]]) {
        
        var citiesById: [String: City] = [:]
        var stationsByCityId: [String: [Station]] = [:]
        
        for country in allStationResponse.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    
                    let countryTitle = (country.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let settlementTitle = (settlement.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let cityTitle = settlementTitle.isEmpty ? countryTitle : settlementTitle
                    
                    let cityId: String = {
                        if let settlementCode = settlement.codes?.yandex_code, !settlementCode.isEmpty {
                            return settlementCode
                        }
                        if let countryCode = country.codes?.yandex_code, !countryCode.isEmpty {
                            return "fallback-\(countryCode)"
                        }
                        return "fallback-\(countryTitle)"
                    }()
                    
                    if citiesById[cityId] == nil {
                        citiesById[cityId] = City(id: cityId, title: cityTitle)
                    }
                    
                    let parsedStations: [Station] = (settlement.stations ?? []).compactMap { dtoStation in
                        
                        guard let stationId = dtoStation.codes?.yandex_code, !stationId.isEmpty else { return nil }
                        let stationTitle = (dtoStation.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !stationTitle.isEmpty else { return nil }
                        let stationType = (dtoStation.station_type ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        return Station(id: stationId, title: stationTitle, stationType: stationType)
                    }
                    
                    guard !parsedStations.isEmpty else { continue }
                    
                    let existing = stationsByCityId[cityId] ?? []
                    stationsByCityId[cityId] = mergeStations(existing: existing, new: parsedStations)
                }
            }
        }
        
        return (citiesById, stationsByCityId)
    }
    
    // MARK: - Helpers
    
    private func mergeStations(existing: [Station], new: [Station]) -> [Station] {
        var seen = Set(existing.map(\.id)) // то же самое, что { $0.id }
        var result = existing
        for station in new where !seen.contains(station.id) {
            result.append(station)
            seen.insert(station.id)
        }
        return result
    }
}
