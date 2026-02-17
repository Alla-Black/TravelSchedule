import SwiftUI

// MARK: - Enums

enum Tab: Hashable {
    case main
    case settings
}

// MARK: - TabBarView

struct TabBarView: View {
    // MARK: - State
    
    @State private var selection: Tab = .main
    
    // MARK: - Initializers
    
    init() {
        configureTabBarAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selection) {
            MainScreen()
                .tabItem {
                    Image(.mainItem)
                }
                .tag(Tab.main) // метка для связи вкладки со значением selection
            
            SettingsScreen()
                .tabItem {
                    Image(.settingsItem)
                }
                .tag(Tab.settings)
        }
        .tint(.blackDayNight) // цвет для выбранного таба
    }
    
    // MARK: - Private Methods
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // таббар будет считаться непрозрачным по поведению
        appearance.backgroundColor = .clear
        appearance.shadowColor = .blackUniversal.withAlphaComponent(0.3)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance // применяем стиль к состоянию при скролле
    }
}

// MARK: - Preview

#Preview {
    TabBarView()
}
