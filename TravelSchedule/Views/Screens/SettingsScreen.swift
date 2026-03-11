import SwiftUI

struct SettingsScreen: View {
    private enum Constants {
        static let themeSettings = "Темная тема"
        static let userAgreement = "Пользовательское соглашение"
        static let apiImplementation = "Приложение использует API «Яндекс.Расписания»"
    }
    
    @AppStorage(AppStorageKeys.isDarkThemeEnabled.rawValue) private var isDarkThemeEnabled: Bool = false
    
    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        return "Версия \(version) (beta)"
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight
                .ignoresSafeArea()
            
            VStack {
                content
                Spacer()
                footer
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            themeRow
            userAgreementRow
        }
        .padding(.top, 24)
    }
    
    private var themeRow: some View {
        HStack {
            Text(Constants.themeSettings)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.blackDayNight)
                .padding(.vertical, 19)
            
            Spacer()
            
            Toggle("", isOn: $isDarkThemeEnabled)
                .tint(.blueUniversal)
                .padding(.leading, 4)
        }
    }
    
    private var userAgreementRow: some View {
        NavigationLink {
            UserAgreementScreen()
        } label: {
            HStack {
                Text(Constants.userAgreement)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackDayNight)
                    .padding(.vertical, 19)
                
                Spacer()
                
                Image(.shevron)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.blackDayNight)
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
    
    private var footer: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(Constants.apiImplementation)
            Text(appVersionText)
        }
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(.blackDayNight)
        .multilineTextAlignment(.center)
        .padding(.bottom, 24)
    }
}

#Preview {
    SettingsScreen()
}
