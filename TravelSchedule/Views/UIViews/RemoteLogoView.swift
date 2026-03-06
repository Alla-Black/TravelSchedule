import SwiftUI

struct RemoteLogoView: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    var cornerRadius: CGFloat
    
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
        .frame(width: width, height: height)
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
        width: 38,
        height: 38,
        cornerRadius: 12
    )
}

#Preview {
    RemoteLogoView(
        url: URL(string: ""),
        width: 38,
        height: 38,
        cornerRadius: 12
    )
}
