import Foundation

struct StoryPage: Identifiable, Hashable, Sendable {
    let id: UUID = UUID()
    let imageName: String
    let title: String
    let text: String
}
