import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    private var isActive: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        HStack() {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(isActive ? Color.blackDayNight : Color.grayUniversal)
            
            TextField(
                "",
                text: $text,
                prompt: Text("Введите запрос")
                    .foregroundStyle(Color.grayUniversal)
            )
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.blackDayNight)
            .textFieldStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isActive {
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
