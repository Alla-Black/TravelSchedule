import SwiftUI

struct CityPickerScreen: View {
    @StateObject private var viewModel: CityPickerViewModel
    
    init(repository: StationsRepository = DefaultStationsRepository()) {
        _viewModel = StateObject(wrappedValue: CityPickerViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.whiteDayNight.ignoresSafeArea()
                VStack(spacing: 16) {
                    SearchBarView(text: $viewModel.query)
                        .padding(.horizontal, 16)
                        .onChange(of: viewModel.query) {
                            viewModel.applyFilter()
                        }
                    
                    // 1) Если загрузка
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // 2) Обработка ошибок
                    } else if let error = viewModel.errorState {
                        ErrorView(state: error)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // 3) Когда город не найден
                    } else if !viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && viewModel.filteredCities.isEmpty {
                        VStack {
                            Spacer()
                            Text("Город не найден")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color.blackDayNight)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 4) Список городов
                    } else {
                        PickerListView(
                            items: viewModel.displayedCities,
                            rowTitle: { $0.title },
                            onSelect: { viewModel.select(city: $0) }
                        )
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Выбор города")
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
}

#Preview {
    CityPickerScreen()
}
