import SwiftUI

struct RouteInputCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            RouteFieldsView()
            SwapButton()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blueUniversal)
        )
    }
}

#Preview {
    RouteInputCardView()
}
