import SwiftUI

struct StoryFullscreenView: View {
    let page: StoryPage
    
    var body: some View {
        ZStack {
            Color.blackUniversal.ignoresSafeArea()
            
            ZStack(alignment: .topTrailing) {
                StoryPageView(page: page)
                
                Button {
                    
                } label: {
                    Image(.close)
                        .frame(width: 30, height: 30)
                }
                .padding(.top, 50)
                .padding(.trailing, 12)
            }
            .padding(.top, 7)
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    let page = StoriesMockData.stories[0].pages[0]
    StoryFullscreenView(page: page)
}
