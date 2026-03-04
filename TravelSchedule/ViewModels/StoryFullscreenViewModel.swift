import Foundation
import Combine

final class StoryFullscreenViewModel: ObservableObject {
    // MARK: - States
    
    @Published private(set) var currentPageIndex: Int = 0
    @Published private(set) var currentStoryIndex: Int
    @Published private(set) var pageProgress: CGFloat = 0
    
    // MARK: - Computed properties
    
    var currentStory: Story? {
        guard stories.indices.contains(currentStoryIndex) else { return nil }
        return stories[currentStoryIndex]
    }
    
    var pages: [StoryPage] {
        currentStory?.pages ?? []
    }
    var pagesCount: Int {
        pages.count
    }
    var totalProgress: CGFloat {
        CGFloat(currentPageIndex) + pageProgress
    }
    
    // MARK: - Public Properties
    
    let stories: [Story]
    let onClose: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let pageDuration: Double = 10
    private let timerInterval: Double = 0.05
    private var cancellable: AnyCancellable? // переменная, где хранится подписка таймера, чтобы таймер не удалился и мы могли его остановить
    
    // MARK: - Init
    
    init(stories: [Story], startIndex: Int, onClose: (() -> Void)? = nil) {
        self.stories = stories
        self.currentStoryIndex = startIndex
        self.onClose = onClose
    }
    
    // MARK: - Public Methods
    
    func setCurrentPageIndex(_ newIndex: Int) {
        guard pagesCount > 0 else { return }
        
        let clamped = min(max(newIndex, 0), pagesCount - 1)
        
        guard clamped != currentPageIndex else { return }
        
        currentPageIndex = clamped
        pageProgress = 0
    }
    
    func goNextPage() {
        // следующая страница в текущей сториз
        if currentPageIndex < pagesCount - 1 {
            currentPageIndex += 1
            pageProgress = 0
            return
        }
        
        // следующая сториз
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
            currentPageIndex = 0
            pageProgress = 0
            return
        }
        
        // просмотр последней сторис завершён — закрываем экран
        onClose?()
    }
    
    func goPrevPage() {
        // предыдущая страница в текущей истории
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            pageProgress = 0
            return
        }
        
        // предыдущая история (переход на ее последнюю страницу)
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            currentPageIndex = max((stories[currentStoryIndex].pages.count) - 1, 0)
            pageProgress = 0
        }
    }
    
    // MARK: - Story Timer
    
    func startTimer() {
        cancellable = Timer
            .publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func timerTick() {
        pageProgress += CGFloat(timerInterval / pageDuration)
        
        if pageProgress >= 1 {
            pageProgress = 0
            goNextPage()
        }
    }
}
