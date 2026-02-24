import SwiftUI

struct ScheduleScreen: View {
    @StateObject private var viewModel: ScheduleScreenViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var filtersModel: ScheduleFiltersModel
    
    let from: Selection
    let to: Selection
    
    private var routeTitle: String {
        "\(from.city.title) (\(from.station.title)) → \(to.city.title) (\(to.station.title))"
    }
    
    private var shouldShowBottomButton: Bool {
        !viewModel.isLoading && viewModel.errorState == nil
    }
    
    init(repository: ScheduleRepository = DefaultScheduleRepository(),
         from: Selection,
         to: Selection
    ) {
        self.from = from
        self.to = to
        
        _viewModel = StateObject(
            wrappedValue: ScheduleScreenViewModel(
                repository: repository,
                from: from.station,
                to: to.station,
                date: Date(),
                transfers: true
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text(routeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.blackDayNight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .lineLimit(nil)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorState {
                    ErrorView(state: error)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.displayedSchedule.isEmpty {
                    VStack {
                        Spacer()
                        Text("Вариантов нет")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.blackDayNight)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.displayedSchedule) { item in
                                ScheduleCardView(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            VStack {
                if shouldShowBottomButton {
                    Spacer()
                    Button("Уточнить время") {
                        navigationModel.push(.scheduleFilters)
                    }
                    .font(.system(size:17, weight: .bold))
                    .foregroundColor(.whiteUniversal)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(.blueUniversal)
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.load()
        }
        .onChange(of: filtersModel.filters) {
            viewModel.applyFilters(filtersModel.filters)
        }
    }
}


