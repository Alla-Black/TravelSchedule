import SwiftUI

struct PickerRowView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color(.blackDayNight))
            Spacer()
            Image(.shevron)
                .padding(.leading, 4)
                .frame(width: 24, height: 24, alignment: .center)
        }
        .padding(.vertical, 19)
        .padding(.leading, 16)
        .padding(.trailing, 18)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PickerRowView(title: "Москва")
}
