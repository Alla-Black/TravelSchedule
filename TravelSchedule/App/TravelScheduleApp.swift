import SwiftUI

@main
struct TravelScheduleApp: App {
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
        }
    }
}
