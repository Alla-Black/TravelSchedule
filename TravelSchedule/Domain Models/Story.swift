import Foundation

struct Story: Identifiable, Hashable, Sendable {
    let id: UUID = UUID()
    let pages: [StoryPage]
    let previewImageName: String
}
