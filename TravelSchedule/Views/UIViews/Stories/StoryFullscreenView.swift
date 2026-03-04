import SwiftUI

struct StoryFullscreenView: View {
    let story: Story
    let progressStub: CGFloat = 0.3
    
    var body: some View {
        ZStack {
            Color.blackUniversal.ignoresSafeArea()
            
            ZStack() {
                let page = story.pages[0]
                StoryPageView(page: page)
                
                    .overlay(alignment: .topTrailing) {
                        Button {
                            
                        } label: {
                            Image(.close)
                                .frame(width: 30, height: 30)
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 12)
                    }
                
                    .overlay(alignment: .top) {
                        StoriesProgressView(numberOfSections: story.pages.count, progress: progressStub)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                            .padding(.top, 28)
                    }
            }
            .padding(.top, 7)
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    let story = StoriesMockData.stories[0]
    StoryFullscreenView(story: story)
}
