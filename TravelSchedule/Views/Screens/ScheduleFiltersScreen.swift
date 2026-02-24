import SwiftUI

struct ScheduleFiltersScreen: View {
    @EnvironmentObject private var filtersModel: ScheduleFiltersModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @StateObject private var viewModel = ScheduleFiltersViewModel()
    
    private enum SectionType: CaseIterable {
        case departureTime
        case transfers
        
        var title: String {
            switch self {
            case .departureTime: return "Время отправления"
            case .transfers: return "Показывать варианты с пересадками"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(SectionType.allCases, id: \.self) { section in
                        Text(section.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blackDayNight)
                            .padding(.top, section == .transfers ? 16 : 0)
                            .padding(.bottom, 16)
                        
                        switch section {
                        case .departureTime:
                            departureTimeSection
                        case .transfers:
                            transfersSection
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            .safeAreaInset(edge: .bottom) {
                if viewModel.isApplyEnabled {
                    Button("Применить") {
                        filtersModel.filters = viewModel.filters
                        navigationModel.pop()
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
        
        .onAppear {
            viewModel.filters = filtersModel.filters
        }
    }
}

private extension ScheduleFiltersScreen {
    var departureTimeSection: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(DepartureTimeRange.allCases, id: \.self) { range in
                Button {
                    viewModel.toggle(range)
                } label: {
                    HStack {
                        Text(range.title)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blackDayNight)
                            .padding(.vertical, 19)
                        
                        Spacer()
                        
                        Image(systemName: viewModel.filters.departureTimeRanges.contains(range) ? "checkmark.square.fill" : "square")
                            .foregroundStyle(.blackDayNight)
                            .frame(width: 20, height: 20)
                            .padding(2)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private extension ScheduleFiltersScreen {
    var transfersSection: some View {
        let options: [(title: String, value: TransfersOption)] = [
            ("Да", .all),
            ("Нет", .onlyDirect)
        ]
        
        return LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(options, id: \.value) { option in
                Button {
                    viewModel.setTransfers(option.value)
                } label: {
                    HStack {
                        Text(option.title)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blackDayNight)
                            .padding(.vertical, 19)
                        
                        Spacer()
                        
                        Image(systemName: viewModel.filters.transfers == option.value ? "largecircle.fill.circle"
                              : "circle")
                        .foregroundStyle(.blackDayNight)
                        .frame(width: 20, height: 20)
                        .padding(2)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ScheduleFiltersScreen()
}
