import SwiftUI

struct MainScreen: View {
    var body: some View {
        ZStack {
            Color.whiteDayNight
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                StoriesCarouselView()
                    .frame(height: 188)
                    .frame(maxWidth: .infinity)
                    .background(Color.whiteUniversal)
                    .border(Color.blueUniversal)
                    .clipped()
                RouteInputCardView()
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MainScreen()
}
