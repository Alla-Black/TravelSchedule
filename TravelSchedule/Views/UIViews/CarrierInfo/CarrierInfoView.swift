import SwiftUI

struct CarrierInfoView: View {
    private enum Constants {
        static let email = "E-mail"
        static let phone = "Телефон"
    }
    
    let carrier: CarrierInfo
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            contactsSection
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RemoteLogoView(
                url: carrier.logoURL,
                width: .infinity,
                height: 104,
                cornerRadius: 24
            )
            
            Text(carrier.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDayNight)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let email = carrier.email {
                contactBlock(
                    title: Constants.email,
                    value: email
                )
            }
            
            if let phone = carrier.phone {
                contactBlock(
                    title: Constants.phone,
                    value: phone
                )
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 44)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func contactBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.blackDayNight)
            
            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.blueUniversal)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let carrier = CarrierInfo(
        title: "ОАО «РЖД»",
        logoURL: URL(string: "https://img.freepik.com/premium-vector/train-logo-brand_1294175-5790.jpg?semt=ais_hybrid&w=740"),
        email: "info@example.com",
        phone: "+7 (800) 123-45-67"
    )
    
    return CarrierInfoView(carrier: carrier)
}
