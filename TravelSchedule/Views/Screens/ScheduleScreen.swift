import SwiftUI

struct ScheduleScreen: View {
    @StateObject private var viewModel: ScheduleScreenViewModel
    
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
                } else if viewModel.schedule.isEmpty {
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
                            ForEach(viewModel.schedule) { item in
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
                        
                    }
                    .frame(width: 343, height: 60)
                    .foregroundColor(.whiteUniversal)
                    .background(.blueUniversal)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.load()
        }
    }
}


