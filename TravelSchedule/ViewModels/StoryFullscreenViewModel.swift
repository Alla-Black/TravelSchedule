import Foundation
import Combine

final class StoryFullscreenViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var currentPageIndex: Int = 0
    @Published private(set) var pageProgress: CGFloat = 0
    
    // MARK: - Computed properties
    
    var pages: [StoryPage] {
        story.pages
    }
    var pagesCount: Int {
        pages.count
    }
    var totalProgress: CGFloat {
        CGFloat(currentPageIndex) + pageProgress
    }
    
    // MARK: - Public Properties
    let story: Story
    let onClose: (() -> Void)?
    
    // MARK: - Initializers
    
    init(story: Story, onClose: (() -> Void)? = nil) {
        self.story = story
        self.onClose = onClose
    }
    
    func goNextPage() {
        guard pagesCount > 0 else {
            onClose?()
            return
        }
        
        if currentPageIndex < pagesCount - 1 {
            currentPageIndex += 1
            pageProgress = 0
        } else {
            onClose?()
        }
    }
    
    func goPrevPage() {
        guard pagesCount > 0 else { return }
        
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            pageProgress = 0
        }
    }
}
