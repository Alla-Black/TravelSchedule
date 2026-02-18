import SwiftUI

struct PickerListView<Item: Identifiable>: View {
    let items: [Item]
    let rowTitle: (Item) -> String
    let onSelect: (Item) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(items) { item in
                    Button {
                        onSelect(item)
                    } label: {
                        PickerRowView(title: rowTitle(item))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    PickerListPreview()
}

private struct PickerListPreview: View {
    private struct PreviewItem: Identifiable {
        let id: String
        let title: String
    }
    
    private let items: [PreviewItem] = [
        .init(id: "1", title: "Москва"),
        .init(id: "2", title: "Санкт‑Петербург"),
        .init(id: "3", title: "Казань")
    ]
    
    var body: some View {
        PickerListView(
            items: items,
            rowTitle: { $0.title },
            onSelect: { _ in }
        )
    }
}
