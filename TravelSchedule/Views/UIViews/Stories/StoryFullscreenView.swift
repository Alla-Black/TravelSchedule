import SwiftUI

struct StoryFullscreenView: View {
    @StateObject private var viewModel: StoryFullscreenViewModel
    
    init(story: Story) {
        self._viewModel = StateObject(wrappedValue: StoryFullscreenViewModel(story: story))
    }
    
    var body: some View {
        ZStack {
            Color.blackUniversal.ignoresSafeArea()
            
            ZStack() {
                GeometryReader { geo in
                    StoryPagesTabView(
                        pages: viewModel.pages,
                        currentPageIndex: viewModel.currentPageIndex,
                        onPageChange: { newIndex in
                            viewModel.setCurrentPageIndex(newIndex)
                        }
                    )
                    .simultaneousGesture( // позволяет совместить тап и свайп
                        SpatialTapGesture().onEnded { value in
                            if value.location.x < geo.size.width / 2 {
                                viewModel.goPrevPage()
                            } else {
                                viewModel.goNextPage()
                            }
                        }
                    )
                }
                
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.onClose?()
                    } label: {
                        Image(.close)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 12)
                }
                
                .overlay(alignment: .top) {
                    StoriesProgressView(numberOfSections: viewModel.pagesCount, progress: viewModel.totalProgress)
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
