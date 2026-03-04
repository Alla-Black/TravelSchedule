import SwiftUI

/// View, отвечающая за отображение страниц сторис и свайп между ними.
/// Использует TabView в режиме page для горизонтального перелистывания.
struct StoryPagesTabView: View {
    @State private var selection: Int
    
    let pages: [StoryPage]
    let currentPageIndex: Int
    let onPageChange: (Int) -> Void
    
    init(pages: [StoryPage], currentPageIndex: Int, onPageChange: @escaping (Int) -> Void) {
        self.pages = pages
        self.currentPageIndex = currentPageIndex
        self.onPageChange = onPageChange
        _selection = State(initialValue: currentPageIndex)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(pages.indices, id: \.self) { index in
                StoryPageView(page: pages[index])
                    .tag(index) // уникальный идентификатор страницы
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // включает поведение свайпа
        .onChange(of: selection) { _, newValue in
            onPageChange(newValue)
        }
        .onChange(of: currentPageIndex) { _, newValue in
            // синхронизация TabView в случае изменения индекса программно (тап/таймер)
            if selection != newValue {
                selection = newValue
            }
        }
    }
}

#Preview {
    StoryPagesTabView(
        pages: StoriesMockData.stories.first?.pages ?? [],
        currentPageIndex: 0,
        onPageChange: {_ in }
    )
}
