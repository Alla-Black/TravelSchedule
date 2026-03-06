import SwiftUI

struct SettingsScreen: View {
    private enum Constants {
        static let themeSettings = "Темная тема"
        static let userAgreement = "Пользовательское соглашение"
        static let apiImplementation = "Приложение использует API «Яндекс.Расписания»"
    }
    
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled: Bool = false
    
    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        return "Версия \(version) (beta)"
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 0) {
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
                }
                .padding(.top, 24)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    Text(Constants.apiImplementation)
                    Text(appVersionText)
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.blackDayNight)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    SettingsScreen()
}
