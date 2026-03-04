import SwiftUI

extension CGFloat {
    static let progressBarCornerRadius: CGFloat = 3
    static let progressBarHeight: CGFloat = 6
}

struct StoriesProgressView: View {
    let numberOfSections: Int
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: .progressBarHeight)
                    .foregroundColor(.whiteUniversal)
                
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: min( // min(..., fullWidth) защищает от ситуации, когда progress > 1 (чтобы не вылезло)
                        progress * geometry.size.width,
                        geometry.size.width
                    ),
                           height: .progressBarHeight
                    )
                    .foregroundColor(.blueUniversal)
            }
            .mask {
                MaskView(numberOfSections: numberOfSections)
            }
        }
    }
}

private struct MaskView: View {
    let numberOfSections: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: .progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: .progressBarHeight)
            .foregroundStyle(.whiteUniversal)
    }
}

#Preview {
    Color.blackUniversal
        .ignoresSafeArea()
        .overlay(
            StoriesProgressView(numberOfSections: 2, progress: 0.5)
                .padding()
        )
}
