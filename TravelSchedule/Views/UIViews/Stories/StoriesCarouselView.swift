import SwiftUI

struct StoriesCarouselView: View {
    let stories: [Story]
    let onTap: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stories.indices, id: \.self) { index in
                    let story = stories[index]
                    let previewPage = story.pages.first
                    
                    ZStack(alignment: .bottomLeading) {
                        Image(story.previewImageName)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Text(previewPage?.title ?? "")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.whiteUniversal)
                            .lineLimit(3)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 12)
                    }
                    .frame(width: 92, height: 140)
                    .onTapGesture { onTap(index) }
                }
            }
        }
        .padding(.leading, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
        StoriesCarouselView(stories: StoriesMockData.stories) { index in
            print("Tapped story:", index)
        }
}
