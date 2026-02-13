import SwiftUI

struct RouteFieldsView: View {
    @State private var from: String = ""
    @State private var to: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TextField(
                "",
                text: $from,
                prompt: Text("Откуда")
                    .foregroundStyle(Color.grayUniversal)
            )
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.blackUniversal)
            .textFieldStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
            .padding(.horizontal, from.isEmpty ? 16 : 13)
            
            TextField(
                "",
                text: $to,
                prompt: Text("Куда")
                    .foregroundStyle(Color.grayUniversal)
            )
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(Color.blackUniversal)
            .textFieldStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
            .padding(.horizontal, to.isEmpty ? 16 : 13)
        }
        
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.whiteUniversal)
        )
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    RouteFieldsView()
}
