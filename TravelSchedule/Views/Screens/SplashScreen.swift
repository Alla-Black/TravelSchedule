import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainScreen()
        } else {
            Image(.splashScreen)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}
#Preview {
    SplashScreen()
}
