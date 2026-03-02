import Foundation

private typealias Country = Components.Schemas.Country
private typealias Settlement = Components.Schemas.Settlement

final class StationsReferenceParser {
    
    func parse(allStationResponse: AllStationsResponse) -> (citiesById: [String: City], stationsByCityId: [String: [Station]]) {
        
        var citiesById: [String: City] = [:]
        var stationsByCityId: [String: [Station]] = [:]
        
        for country in allStationResponse.countries ?? [] {
            process(
                country: country,
                citiesById: &citiesById,
                stationsByCityId: &stationsByCityId
            )
        }
        
        return (citiesById, stationsByCityId)
    }
    
    // MARK: - Helpers
    
    private func process(
        country: Country,
        citiesById: inout [String: City],
        stationsByCityId: inout [String: [Station]]
    ) {
        for region in country.regions ?? [] {
            for settlement in region.settlements ?? [] {
                
                let (cityId, city) = makeCity(country: country, settlement: settlement)
                
                if citiesById[cityId] == nil {
                    citiesById[cityId] = city
                }
                
                let parsedStations = parseStations(settlement: settlement)
                guard !parsedStations.isEmpty else { continue }
                
                let existing = stationsByCityId[cityId] ?? []
                stationsByCityId[cityId] = mergeStations(existing: existing, new: parsedStations)
            }
        }
    }
    
    private func makeCity(country: Country, settlement: Settlement) -> (id: String, city: City) {
        let countryTitle = normalize(country.title)
        let settlementTitle = normalize(settlement.title)
        let cityTitle = settlementTitle.isEmpty ? countryTitle : settlementTitle
        
        let cityId = makeCityId(
            country: country,
            settlement: settlement,
            countryTitle: countryTitle
        )
        
        return (cityId, City(id: cityId, title: cityTitle))
    }
    
    private func makeCityId(country: Country, settlement: Settlement, countryTitle: String) -> String {
        if let settlementCode = settlement.codes?.yandex_code, !settlementCode.isEmpty {
            return settlementCode
        }
        if let countryCode = country.codes?.yandex_code, !countryCode.isEmpty {
            return "fallback-\(countryCode)"
        }
        return "fallback-\(countryTitle)"
    }
    
    private func parseStations(settlement: Settlement) -> [Station] {
        (settlement.stations ?? []).compactMap { dtoStation in
            guard let stationId = dtoStation.codes?.yandex_code, !stationId.isEmpty else { return nil }
            
            let stationTitle = normalize(dtoStation.title)
            guard !stationTitle.isEmpty else { return nil }
            
            let stationType = normalize(dtoStation.station_type)
            return Station(id: stationId, title: stationTitle, stationType: stationType)
        }
    }
    
    private func normalize(_ value: String?) -> String {
        (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
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
