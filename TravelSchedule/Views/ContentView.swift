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
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Test API call
let apikey = "YOUR API KEY"

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
