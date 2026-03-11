import SwiftUI

struct RouteFieldsView: View {
    @EnvironmentObject private var routeModel: RouteSelectionModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button {
                navigationModel.push(.city(.from))
            } label: {
                Text(routeModel.from?.displayTitle ?? "Откуда")
                    .font(.system(size: 17))
                    .foregroundStyle(routeModel.from == nil ? Color.grayUniversal : Color.blackUniversal)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
            }
            .buttonStyle(.plain)
            
            Button {
                navigationModel.push(.city(.to))
            } label: {
                Text(routeModel.to?.displayTitle ?? "Куда")
                    .font(.system(size: 17))
                    .foregroundStyle(routeModel.to == nil ? Color.grayUniversal : Color.blackUniversal)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
            }
            .buttonStyle(.plain)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.whiteUniversal)
        )
    }
}
