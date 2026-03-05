import SwiftUI

struct StoriesCarouselView: View {
    let stories: [Story]
    let onTap: (Int) -> Void
    let seenStoryIDs: Set<UUID>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stories.indices, id: \.self) { index in
                    let story = stories[index]
                    let isSeen = seenStoryIDs.contains(story.id)
                    let previewPage = story.pages.first
                    
                    ZStack(alignment: .bottomLeading) {
                        Image(story.previewImageName)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .opacity(isSeen ? 0.5 : 1.0)
                        
                        
                        Text(previewPage?.title ?? "")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.whiteUniversal)
                            .lineLimit(3)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 12)
                    }
                    .frame(width: 92, height: 140)
                    .onTapGesture {
                        onTap(index)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 16).inset(by: 2)
                            .stroke(isSeen ? Color.clear : .blueUniversal, lineWidth: 4)
                    }
                }
            }
        }
        .frame(height: 140)
    }
}

#Preview {
    StoriesCarouselView(
        stories: StoriesMockData.stories,
        onTap: { index in
            print("Tapped story:", index)
        },
        seenStoryIDs: []
    )
}
