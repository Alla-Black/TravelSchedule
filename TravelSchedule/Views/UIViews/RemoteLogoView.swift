import SwiftUI

struct RemoteLogoView: View {
    let url: URL?
    var size: CGFloat = 38
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private var placeholder: some View {
        Image(.logoСarrier)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    RemoteLogoView(
        url: URL(string: "https://img.freepik.com/premium-vector/train-logo-brand_1294175-5790.jpg?semt=ais_hybrid&w=740"),
        size: 38,
        cornerRadius: 12
    )
}

#Preview {
    RemoteLogoView(
        url: URL(string: ""),
        size: 38,
        cornerRadius: 12
    )
}
