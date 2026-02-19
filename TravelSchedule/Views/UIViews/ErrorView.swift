import SwiftUI

struct ErrorView: View {
    let state: AppErrorState
    var body: some View {
        ZStack {
            Color.whiteDayNight
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Image(state.imageName)
                    .resizable()
                    .frame(width: 223, height: 223)
                Text(state.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.blackDayNight)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ErrorView(state: .noInternet)
}

#Preview {
    ErrorView(state: .server)
}
