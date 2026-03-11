import SwiftUI

struct StoryFullscreenView: View {
    @StateObject private var viewModel: StoryFullscreenViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let stories: [Story]
    private let onStorySeen: (UUID) -> Void
    
    init(stories: [Story], startIndex: Int, onStorySeen: @escaping (UUID) -> Void) {
        self.stories = stories
        self.onStorySeen = onStorySeen
        self._viewModel = StateObject(
            wrappedValue: StoryFullscreenViewModel(stories: stories, startIndex: startIndex)
        )
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
            .onAppear {
                viewModel.onClose = { dismiss() }
                viewModel.startTimer()
                
                if !stories.isEmpty {
                    let id = stories[viewModel.currentStoryIndex].id
                    onStorySeen(id)
                }
            }
            .onDisappear {
                viewModel.stopTimer()
            }
            .onChange(of: viewModel.currentStoryIndex) {
                let index = viewModel.currentStoryIndex
                guard stories.indices.contains(index) else { return }
                onStorySeen(stories[index].id)
            }
            .swipeDownToDismiss {
                viewModel.onClose?()
            }
        }
    }
}

#Preview {
    StoryFullscreenView(
        stories: StoriesMockData.stories,
        startIndex: 0,
        onStorySeen: { _ in }
    )
}
