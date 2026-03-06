import SwiftUI

struct UserAgreementScreen: View {
    private enum Constants {
        static let userAgreementTitle = "Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц"
        
        static let offerDescription = """
        Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer
        
        Российская Федерация, город Москва
        """
        
        static let chapterOneTitle = "1. ТЕРМИНЫ"
        
        static let chapterOneText = """
        Понятия, используемые в Оферте, означают следующее:
        
        Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.
        
        Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
        """
        
        static let titleFontSize: CGFloat = 24
        static let bodyFontSize: CGFloat = 17
        static let sectionSpacing: CGFloat = 24
        static let textSpacing: CGFloat = 8
    }
    
    var body: some View {
        ZStack {
            Color.whiteDayNight.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    agreementSection
                    chapterOneSection
                }
                .foregroundStyle(.blackDayNight)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
        }
    }
    
    private var agreementSection: some View {
        VStack(alignment: .leading, spacing: Constants.textSpacing) {
            Text(Constants.userAgreementTitle)
                .font(.system(size: Constants.titleFontSize, weight: .bold))
            Text(Constants.offerDescription)
                .font(.system(size: Constants.bodyFontSize, weight: .regular))
        }
    }
    
    private var chapterOneSection: some View {
        VStack(alignment: .leading, spacing: Constants.textSpacing) {
            Text(Constants.chapterOneTitle)
                .font(.system(size: Constants.titleFontSize, weight: .bold))
            Text(Constants.chapterOneText)
                .font(.system(size: Constants.bodyFontSize, weight: .regular))
        }
    }
}

#Preview {
    UserAgreementScreen()
}
