import SwiftUI

struct StationPickerScreen: View {
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
                
                // 1. Если загрузка
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // 2. Обработка ошибок
                } else if let error = viewModel.errorState {
                    ErrorView(state: error)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                // 3) Пусто без поиска: ничего не введено, но список пустой
                else if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && viewModel.filteredStations.isEmpty {
                    VStack {
                        Spacer()
                        Text("Станций не найдено")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.blackDayNight)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // 4. Пусто после поиска: ввели текст, но совпадений нет
                } else if
                    !viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && viewModel.filteredStations.isEmpty {
                    VStack {
                        Spacer()
                        Text("Станций не найдено")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.blackDayNight)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // 5. Список станций
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
                Text("Выбор станции")
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


