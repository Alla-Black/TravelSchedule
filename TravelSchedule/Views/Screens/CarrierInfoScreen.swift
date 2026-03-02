import SwiftUI

struct CarrierInfoScreen: View {
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            Text("Информация о перевозчике")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.blackDayNight)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
