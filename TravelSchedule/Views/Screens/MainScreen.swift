import SwiftUI

struct MainScreen: View {
    @EnvironmentObject private var routeModel: RouteSelectionModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @State private var seenStoryIDs: Set<UUID> = []
    @State private var isShowingStories = false
    @State private var selectedStoryIndex = 0
    
    var body: some View {
        ZStack() {
            Color.whiteDayNight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                StoriesCarouselView(
                    stories: StoriesMockData.stories,
                    onTap: { index in
                        selectedStoryIndex = index
                        let id = StoriesMockData.stories[index].id
                        seenStoryIDs.insert(id)
                        
                        isShowingStories = true
                    },
                    seenStoryIDs: seenStoryIDs
                )
                .padding(.leading, 16)
                .padding(.vertical, 24)
                .padding(.bottom, 20)
                
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
        .fullScreenCover(isPresented: $isShowingStories) {
            StoryFullscreenView(
                stories: StoriesMockData.stories,
                startIndex: selectedStoryIndex
            )
        }
    }
}

#Preview { MainScreen()
        .environmentObject(RouteSelectionModel())
        .environmentObject(NavigationModel())
}
