import Foundation

struct StoryPage: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let text: String
}
