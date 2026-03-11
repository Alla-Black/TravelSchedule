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
            let sections = max(numberOfSections, 1) // защита от 0
            let clamped = min(max(progress, 0), CGFloat(sections)) // 0...sections
            // min(..., fullWidth) защищает от ситуации, когда progress > 1 (чтобы не вылезло)
            let fraction = clamped / CGFloat(sections) // 0...1
            let filledWidth = fraction * geometry.size.width
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: .progressBarHeight)
                    .foregroundColor(.whiteUniversal)
                
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: filledWidth, height: .progressBarHeight)
                    .foregroundColor(.blueUniversal)
            }
            .mask {
                MaskView(numberOfSections: sections)
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
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: .progressBarCornerRadius)
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
