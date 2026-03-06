import SwiftUI

struct CarrierInfoScreen: View {
    @StateObject private var viewModel: CarrierInfoViewModel
    
    init(
        code: String,
        repository: CarrierInfoRepository = DefaultCarrierInfoRepository()
    ) {
        _viewModel = StateObject(
            wrappedValue: CarrierInfoViewModel(
                repository: repository,
                carrierCode: code
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .error(let error):
                ErrorView(state: error)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .idle, .loaded:
                if let carrier = viewModel.carrierInfo {
                    CarrierInfoView(carrier: carrier)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.blackDayNight)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        CarrierInfoScreen(code: "680")
    }
}
