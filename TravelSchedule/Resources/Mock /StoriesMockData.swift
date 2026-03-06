import Foundation

enum StoriesMockData {

    private static let titleStub =
    "Text Text Text Text Text Text Text Text Text Text"

    private static let textStub =
    "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"

    static let stories: [Story] = (1...9).map { storyIndex in
        let pages: [StoryPage] = (1...2).map { pageIndex in
            StoryPage(
                id: UUID(),
                imageName: "story_\(storyIndex)_page_\(pageIndex)",
                title: titleStub,
                text: textStub
            )
        }

        let previewImageName = "story_\(storyIndex)_preview"
        
        return Story(
            id: UUID(),
            pages: pages,
            previewImageName: previewImageName
        )
    }
}
