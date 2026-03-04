import SwiftUI

/// View, отвечающая за отображение страниц сторис и свайп между ними.
/// Использует TabView в режиме page для горизонтального перелистывания.
struct StoryPagesTabView: View {
    let pages: [StoryPage]
    @Binding var currentPageIndex: Int
    
    var body: some View {
        TabView(selection: $currentPageIndex) {
            ForEach(pages.indices, id: \.self) { index in
                StoryPageView(page: pages[index])
                    .tag(index) // уникальный идентификатор страницы
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // включает поведение свайпа
    }
}

#Preview {
    StoryPagesTabView(
        pages: StoriesMockData.stories.first?.pages ?? [],
        currentPageIndex: .constant(0)
    )
}
