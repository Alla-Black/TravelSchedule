import SwiftUI

// MARK: - Enums

enum Tab: Hashable {
    case main
    case settings
}

// MARK: - TabBarView

struct TabBarView: View {
    // MARK: - Dependencies
    
    private let stationsRepository: StationsRepository = DefaultStationsRepository()
    
    // MARK: - State
    
    @State private var selection: Tab = .main
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var routeModel = RouteSelectionModel()
    @StateObject private var filtersModel = ScheduleFiltersModel()
    
    // MARK: - Initializers
    
    init() {
        configureTabBarAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selection) {
            mainTab
            settingsTab
        }
        .tint(.blackDayNight)
    }
    
    // MARK: - Tabs
    
    private var mainTab: some View {
        NavigationStack(path: $navigationModel.path) {
            mainRoot
        }
        .environmentObject(routeModel)
        .environmentObject(navigationModel)
        .environmentObject(filtersModel)
        .tabItem {
            Image(.mainItem)
        }
        .tag(Tab.main) // метка для связи вкладки со значением selection
    }
    
    private var settingsTab: some View {
        NavigationStack {
            SettingsScreen()
        }
        .tabItem {
            Image(.settingsItem)
        }
        .tag(Tab.settings)
    }
    
    // MARK: - Main Root
    private var mainRoot: some View {
        MainScreen()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Screen.self) { screen in
                destination(for: screen)
            }
    }
    
    // MARK: - Navigation
    
    @ViewBuilder
    private func destination(for screen: Screen) -> some View {
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
                handleStationSelection(direction: direction, selection: selection)
            }
            
        case .schedule(let from, let to):
            ScheduleScreen(
                from: from,
                to: to
            )
            
        case .scheduleFilters:
            ScheduleFiltersScreen()
            
        case .carrierInfo(let code):
            CarrierInfoScreen(code: code)
        }
    }
    
    private func handleStationSelection(
        direction: Direction,
        selection: Selection
    ) {
        switch direction {
        case .from:
            routeModel.from = selection
        case .to:
            routeModel.to = selection
        }
        navigationModel.popToRoot()
    }
    
    // MARK: - Appearance
    
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
