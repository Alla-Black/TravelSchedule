import SwiftUI

struct CityPickerScreen: View {
    @StateObject private var viewModel: CityPickerViewModel
    
    let onSelectedCity: (City) -> Void
    
    init(repository: StationsRepository = DefaultStationsRepository(), onSelectedCity: @escaping (City) -> Void) {
        self.onSelectedCity = onSelectedCity
        _viewModel = StateObject(wrappedValue: CityPickerViewModel(repository: repository))
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
                    let trimmedQuery = viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if !trimmedQuery.isEmpty && viewModel.filteredCities.isEmpty {
                        VStack {
                            Spacer()
                            Text("Город не найден")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color.blackDayNight)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        PickerListView(
                            items: viewModel.displayedCities,
                            rowTitle: { $0.title },
                            onSelect: {
                                onSelectedCity($0)
                            }
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Выбор города")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.blackDayNight)
                }
            }
            .navigationTitle("")
            .toolbar(.hidden, for: .tabBar) // спрятать таббар
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load()
            }
        }
    }
}
