import SwiftUI

// MARK: - Enums

enum Tab: Hashable {
    case main
    case settings
}

// MARK: - TabBarView

struct TabBarView: View {
    // MARK: - Private Properties
    
    private let stationsRepository: StationsRepository = DefaultStationsRepository()
    
    // MARK: - State
    
    @State private var selection: Tab = .main
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var routeModel = RouteSelectionModel()
    
    // MARK: - Initializers
    
    init() {
        configureTabBarAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack(path: $navigationModel.path) {
                MainScreen()
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: Screen.self) { screen in
                        switch screen {
                            
                        case .city(let direction):
                            CityPickerScreen(repository: stationsRepository) { city in
                                navigationModel.push(.station(direction, city))
                            }
                            
                        case .station(let direction, let city):
                            StationPickerScreen(
                                repository: stationsRepository,
                                city: city
                            ) { selection in
                                switch direction {
                                case .from:
                                    routeModel.from = selection
                                case .to:
                                    routeModel.to = selection
                                }
                                navigationModel.popToRoot()
                            }
                            
                        case .schedule(let from, let to):
                            ScheduleScreen(
                                from: from,
                                to: to
                            )
                            
                        case .scheduleFilters:
                            ScheduleFiltersScreen()
                        }
                    }
            }
            .environmentObject(routeModel)
            .environmentObject(navigationModel)
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
