import Foundation

struct Story: Identifiable, Hashable {
    let id: UUID
    let pages: [StoryPage]
    let previewImageName: String
}
