import SwiftUI

struct StationPickerScreen: View {
    private enum Constants {
        static let emptyStationsTitle = "Станций не найдено"
        static let navigationTitle = "Выбор станции"
    }
    
    @StateObject private var viewModel: StationPickerViewModel
    
    private let city: City
    private let onSelect: (Selection) -> Void
    
    init(
        repository: StationsRepository = DefaultStationsRepository(),
        city: City,
        onSelect: @escaping (Selection) -> Void
    ) {
        self.city = city
        self.onSelect = onSelect
        _viewModel = StateObject(wrappedValue: StationPickerViewModel(repository: repository, city: city))
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            VStack(spacing: 16) {
                SearchBarView(text: $viewModel.query)
                    .padding(.horizontal, 16)
                    .onChange(of: viewModel.query) {
                        viewModel.applyFilter()
                    }
                
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .error(let error):
                    ErrorView(state: error)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .idle, .loaded:
                    
                    if viewModel.filteredStations.isEmpty {
                        VStack {
                            Spacer()
                            Text(Constants.emptyStationsTitle)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color.blackDayNight)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        PickerListView(
                            items: viewModel.filteredStations,
                            rowTitle:  { $0.title },
                            onSelect: { station in
                                let selection = Selection(city: city, station: station)
                                onSelect(selection)
                            }
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Constants.navigationTitle)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.blackDayNight)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load()
            }
        }
    }
}

