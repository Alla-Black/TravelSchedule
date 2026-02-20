import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    private var hasText: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var shouldShowClearButton: Bool {
        isFocused
    }
    
    var body: some View {
        HStack() {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(hasText ? Color.blackDayNight : Color.grayUniversal)
            
            TextField(
                "",
                text: $text,
                prompt: Text("Введите запрос")
                    .foregroundStyle(Color.grayUniversal)
            )
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.blackDayNight)
            .textFieldStyle(.plain)
            .tint(Color.blueUniversal)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if shouldShowClearButton {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.grayUniversal)
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .padding(.leading, 8)
        .padding(.trailing, 6)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightGray)
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}

#Preview {
    SearchBarView(text: .constant("Москва"))
}
