import SwiftUI

struct RouteInputCardView: View {
    @EnvironmentObject private var routeModel: RouteSelectionModel
    
    var body: some View {
        HStack(spacing: 16) {
            RouteFieldsView()
            SwapButton(action: { routeModel.swap() })
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blueUniversal)
        )
    }
}
