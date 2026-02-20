import SwiftUI

struct SwapButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.2.squarepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.blueUniversal)
                .background(
                    Circle()
                        .fill(.whiteUniversal)
                        .frame(width: 36, height: 36)
                )
                .frame(width: 36, height: 36)
                .contentShape(Circle())
        }
    }
}
