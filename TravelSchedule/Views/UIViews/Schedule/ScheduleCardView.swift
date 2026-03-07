import SwiftUI

struct ScheduleCardView: View {
    let item: ScheduleCardItem
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: 0) {
                    RemoteLogoView(
                        url: item.carrierLogoURL,
                        width: 38,
                        height: 38,
                        cornerRadius: 12,
                        contentMode: .fill
                    )
                    .padding(.trailing, 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.carrierTitle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.blackUniversal)
                        
                        if let subtitle = item.transfersSubtitle {
                            Text(subtitle)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.redUniversal)
                        }
                    }
                    Spacer()
                }
                
                Text(item.dateTitle)
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(1)
                    .foregroundStyle(.blackUniversal)
            }
            .padding(.top, 14)
            .padding(.leading, 14)
            .padding(.trailing, 7)
            
            HStack(spacing: 5) {
                HStack(spacing: 4) {
                    Text(item.departureTimeTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundStyle(Color.grayUniversal)
                }
                
                Text(item.durationTitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.blackUniversal)
                
                HStack(spacing: 4) {
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundStyle(Color.grayUniversal)
                    
                    Text(item.arrivalTimeTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                }
            }
            .padding(14)
        }
        .background(.lightGrayUniversal)
        .cornerRadius(24)
    }
}

#Preview {
    ScheduleCardView(
        item: ScheduleCardItem(
            uid: "test",
            departureRawString: "2026-01-14T22:30:00+03:00",
            carrierTitle: "РЖД",
            carrierLogoURL: URL(string: "https://img.freepik.com/premium-vector/train-logo-brand_1294175-5790.jpg?semt=ais_hybrid&w=740"),
            dateTitle: "14 января",
            departureTimeTitle: "22:30",
            arrivalTimeTitle: "08:15",
            durationTitle: "20 часов",
            hasTransfers: true,
            carrierCode: "680"
        )
    )
}

#Preview {
    ScheduleCardView(
        item: ScheduleCardItem(
            uid: "test",
            departureRawString: "2026-01-14T22:30:00+03:00",
            carrierTitle: "РЖД",
            carrierLogoURL: URL(string: "https://img.freepik.com/premium-vector/train-logo-brand_1294175-5790.jpg?semt=ais_hybrid&w=740"),
            dateTitle: "14 января",
            departureTimeTitle: "22:30",
            arrivalTimeTitle: "08:15",
            durationTitle: "20 часов",
            hasTransfers: false,
            carrierCode: "680"
        )
    )
}
