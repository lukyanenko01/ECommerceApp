//
//  CartDetailPage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 12.06.2023.
//

import SwiftUI
import iPhoneNumberField

struct CartDetailPage: View {
    
    @EnvironmentObject var sharedDataModel: SharedDataModel
    
    @State var selectedPaymentOption: PaymentOption? = .cash
    @State var delivery = 0
    
    @State private var name = ""
    @State private var phone = ""
    @State private var location = ""
    @State private var comment = ""

    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State var isShowingLocationSearch: Bool = false

    
    var body: some View {
        VStack(spacing: 10) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack {
                        Text("Спосіб отримання")
                            .font(.custom(customFont, size: 20).bold())
                        
                        if delivery == 1 {
                            Text("Доставка сплачується після отримання. Ціна залежить від района міста і прораховується менеджером після підтвердження замовлення.")
                                .font(.custom(customFont, size: 18))
                                .foregroundColor(.gray)
                                .padding(.top)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        CustomSegmentedControl(selectedSegment: $delivery, segments: ["З собою", "Доставка"])
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("Спосіб оплати")
                            .font(.custom(customFont, size: 20).bold())
                        RadioButtonGroup(selectedOption: $selectedPaymentOption)
                        
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("Дані для замовлення")
                            .font(.custom(customFont, size: 20).bold())
                        
                        CustomTextField(text: $name, hint: "Ім'я", leadingIcon: Image(systemName: "person"))
                        CustomTextField(text: $phone, hint: "Телефон", leadingIcon: Image(systemName: "phone"), isPhone: true)
                        
                        
                        
                        if delivery == 1 {
                            Button(action: {
                                isShowingLocationSearch = true
                            }) {
                                CustomTextField(text: $location, hint: "Адреса доставки", leadingIcon: Image(systemName: "location"))
                            }
                            .sheet(isPresented: $isShowingLocationSearch) {
                                SearchLocationView(location: $location, isShowing: $isShowingLocationSearch)
                            }
                        }
                    }
                    VStack {
                        Text("Коментар до замовлення")
                            .font(.custom(customFont, size: 20).bold())
                        
                        VStack() {
                            TextEditor(text: $comment)
                                .frame(minHeight: 40)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.gray.opacity(0.1))
                        }
                    }

                }
                .padding([.horizontal, .bottom], 20)
                .padding(.top,25)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Group {
                HStack {
                    Text("Всього")
                        .font(.custom(customFont, size: 14))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(sharedDataModel.getTotalPrice())
                        .font(.custom(customFont, size: 18).bold())
                        .foregroundColor(.orange)
                }
                
                
                
                Button {
                    if fieldsAreValid() {
                        sharedDataModel.confirmOrder(name: name, location: location, phone: phone, delivery: delivery, selectedPaymentOption: selectedPaymentOption, comment: comment) { result in
                            switch result {
                            case .success(_):
                                print("Order successfully saved.")
                                alertTitle = "Замовлення"
                                alertMessage = "Ваше замовлення прийнято!"
                                showingSuccessAlert = true
                            case .failure(let error):
                                print("Failed to save order: \(error)")
                                alertTitle = "Помилка замовлення"
                                alertMessage = "Виникла проблема при надсиланні вашого замовлення. Будь ласка, спробуйте ще раз пізніше."
                                showingErrorAlert = true
                            }
                        }
                    } else {
                        alertTitle = "Помилка введення"
                        alertMessage = "Будь ласка, заповніть всі поля!"
                        showingErrorAlert = true
                    }
                } label: {
                    Text("Підтвердити")
                        .font(.custom(customFont, size: 18).bold())
                        .foregroundColor(.white)
                        .padding(.vertical,18)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                }
                .padding(.vertical)
                
            }
            .padding(.horizontal,25)
        }
        .dismissKeyboardOnTap()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .alert(isPresented: $showingSuccessAlert) {
            Alert(
                title: Text("Замовлення"),
                message: Text("Ваше замовлення прийнято!"),
                dismissButton: .default(Text("ОК"))
            )
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("ОК"))
            )
        }
        .onAppear(perform: loadProfile)

    }
    
    func fieldsAreValid() -> Bool {
        if name.isEmpty || phone.isEmpty || (delivery == 1 && location.isEmpty) {
            alertMessage = "Будь ласка, заповніть всі поля!"
            alertTitle = "Помилка введення"
            showingErrorAlert = true
            return false
        }
        return true
    }
    
    
    func loadProfile() {
        // Проверяем, залогинен ли пользователь
        if AuthService.shared.isLoggedIn {
            AuthService.shared.dataBaseService.getProfile { result in
                switch result {
                case .success(let profile):
                    self.name = profile.name
                    self.phone = profile.phone
                case .failure(let error):
                    print("Failed to load profile: \(error)")
                }
            }
        }
    }

}



//struct CartDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CartDetailPage()
//    }
//}


enum PaymentOption: String, CaseIterable {
    case card = "Картою при отримані"
    case cash = "Готівкою"
}

struct RadioButtonGroup: View {
    @Binding var selectedOption: PaymentOption?
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(PaymentOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(selectedOption == option ? Color.orange : Color.clear)
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        Text(option.rawValue)
                            .font(.custom(customFont, size: 18))
                    }
                }
                .foregroundColor(selectedOption == option ? .orange : .gray)
            }
        }
    }
}


struct DismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                
                keyWindow?.endEditing(true)
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboard())
    }
}
