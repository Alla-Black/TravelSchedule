import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetchNearestStations()
            testFetchCopyright()
            testFetchScheduleBetweenStations()
            testFetchStationSchedule()
            testFetchTreadStations()
            testFetchNearestCity()
            testFetchCarrierInfo()
            testFetchAllStations()
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Test API call
private let apikey: String = AppConfiguration.apiKey

func makeClient() throws -> Client {
    Client(
        serverURL: try Servers.Server1.url(),
        transport: URLSessionTransport()
    )
}

func runTest<T>(
    title: String,
    action: @escaping () async throws -> T
) {
    Task {
        print("Fetching \(title)...")
        do {
            let result = try await action()
            print("Successfully fetched \(title): \(result)")
        } catch {
            print("Error fetching \(title): \(error)")
        }
    }
}

func testFetchNearestStations() {
    runTest(title: "nearest stations") {
        let client = try makeClient()
        let service = NearestStationsService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getNearestStations(
            lat: 59.864177, // Пример координат
            lng: 30.319163, // Пример координат
            distance: 50    // Пример дистанции
        )
        
        return result
    }
}

func testFetchCopyright() {
    runTest(title: "copyright") {
        let client = try makeClient()
        let service = CopyrightService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getCopyright()
        
        return result
    }
}

func testFetchScheduleBetweenStations() {
    runTest(title: "schedule between stations") {
        let client = try makeClient()
        let service = ScheduleBetweenStationsService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getScheduleBetweenStations(
            from: "s2006004",
            to: "s9602494",
            date: "2026-02-20",
            transfers: true
        )
        
        return result
    }
}

func testFetchStationSchedule() {
    runTest(title: "station schedule") {
        let client = try makeClient()
        let service = StationScheduleService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getStationSchedule(
            station: "s2006004"
        )
        
        return result
    }
}

func testFetchTreadStations() {
    runTest(title: "thread stations") {
        let client = try makeClient()
        let service = ThreadStationsService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getRouteStations(
            uid: "022A_12_2"
        )
        
        return result
    }
}

func testFetchNearestCity() {
    runTest(title: "nearest city") {
        let client = try makeClient()
        let service = NearestCityService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getNearestCity(
            lat: 59.864177, // Пример координат,
            lng: 30.319163, // Пример координат
            distance: 50    // Пример дистанции
        )
        
        return result
    }
}

func testFetchCarrierInfo() {
    runTest(title: "carrier info") {
        let client = try makeClient()
        let service = CarrierInfoService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getCarrierInfo(
            code: "129",
            system: "yandex"
        )
        
        return result
    }
}

func testFetchAllStations() {
    runTest(title: "all stations") {
        let client = try makeClient()
        let service = AllStationsService(
            client: client,
            apikey: apikey
        )
        let result = try await service.getAllStations()
        let parser = StationsReferenceParser()
        let parsed = parser.parse(allStationResponse: result)
        
        printAllStationsSample(result)
        print("Cities: \(parsed.citiesById.count)")
        
        return "Printed sample: 1 country / 1 region / 1 settlement / 1 station"
    }
}

func printAllStationsSample(_ response: TravelSchedule.Components.Schemas.AllStationsResponse) {
    guard let firstCountry = response.countries?.first else {
        print("AllStationsResponse: no countries")
        return
    }
    
    let firstRegion = firstCountry.regions?.first
    let firstSettlement = firstRegion?.settlements?.first
    let firstStation = firstSettlement?.stations?.first
    
    var trimmedCountry = firstCountry
    
    if var region = firstRegion {
        if var settlement = firstSettlement {
            settlement.stations = firstStation.map { [$0] } ?? []
            region.settlements = [settlement]
        } else {
            region.settlements = []
        }
        trimmedCountry.regions = [region]
    } else {
        trimmedCountry.regions = []
    }
    
    let trimmedResponse = TravelSchedule.Components.Schemas.AllStationsResponse(
        countries: [trimmedCountry]
    )
    
    print(trimmedResponse)
}
