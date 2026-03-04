import SwiftUI

struct StoryPageView: View {
    let page: StoryPage
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(page.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
            VStack(alignment: .leading, spacing: 16) {
               
                Text(page.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.whiteUniversal)
                    .lineLimit(2)
                
                Text(page.text)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.whiteUniversal)
                    .lineLimit(3)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    let page = StoriesMockData.stories[0].pages[0]
    StoryPageView(page: page)
}
