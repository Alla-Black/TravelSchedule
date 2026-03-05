import SwiftUI

struct SwipeDownToDismissModifier: ViewModifier {
    @State private var dragOffset: CGFloat = 0
    
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .offset(y: dragOffset)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 120 {
                            onDismiss()
                        } else {
                            withAnimation(.spring()) {
                                dragOffset = 0
                            }
                        }
                    }
            )
    }
}

extension View {
    func swipeDownToDismiss(onDismiss: @escaping () -> Void) -> some View {
        modifier(SwipeDownToDismissModifier(onDismiss: onDismiss))
    }
}
