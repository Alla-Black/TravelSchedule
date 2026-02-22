import SwiftUI

struct MainScreen: View {
    @EnvironmentObject private var routeModel: RouteSelectionModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
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
                    .padding(.horizontal, 16)
                
                VStack(spacing: 16) {
                    RouteInputCardView()
                        .padding(.horizontal, 16)
                    
                    if routeModel.isRouteComplete {
                        Button {
                            guard let from = routeModel.from, let to = routeModel.to else { return }
                            navigationModel.push(.schedule(from: from, to: to))
                        } label: {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color.whiteUniversal)
                        }
                        .frame(width: 150, height: 60)
                        .background(Color.blueUniversal)
                        .cornerRadius(16)
                    }
                }
                Spacer()
            }
        }
    }
}
