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

func testFetchNearestStations() {
    // Создаём Task для выполнения асинхронного кода
    Task {
        do {
            // 1. Создаём экземпляр сгенерированного клиента
            let client = Client(
                // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                serverURL: try Servers.Server1.url(),
                // Указываем, какой транспорт использовать для отправки запросов
                transport: URLSessionTransport()
            )
            
            // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
            let service = NearestStationsService(
                client: client,
                apikey: "YOUR API"
 // !!! ЗАМЕНИТЕ НА СВОЙ РЕАЛЬНЫЙ КЛЮЧ !!!
            )
            
            // 3. Вызываем метод сервиса
            print("Fetching stations...")
            let stations = try await service.getNearestStations(
                lat: 59.864177, // Пример координат
                lng: 30.319163, // Пример координат
                distance: 50    // Пример дистанции
            )
            
            // 4. Если всё успешно, печатаем результат в консоль
            print("Successfully fetched stations: \(stations)")
        } catch {
            // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
            //    она будет поймана здесь, и мы выведем её в консоль
            print("Error fetching stations: \(error)")
            // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
        }
    }
}

func testFetchCopyright() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = CopyrightService(
                client: client,
                apikey: "YOUR API"
            )
            
            print("Fetching stations...")
            let copyright = try await service.getCopyright()
            
            print("Successfully fetched copyright: \(copyright)")
        } catch {
            print("Error fetching stations: \(error)")
        }
    }
}
