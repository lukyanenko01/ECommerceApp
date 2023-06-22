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
    
    @State var selectedPaymentOption: PaymentOption?
    @State var delivery = 0
    
    @State private var name = ""
    @State private var phone = ""
    @State private var location = ""
    
    @State private var showingAlert = false
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
                    sharedDataModel.confirmOrder(name: name, location: location, phone: phone, delivery: delivery, selectedPaymentOption: selectedPaymentOption) { result in
                        switch result {
                        case .success(_):
                            print("Order successfully saved.")
                            showingAlert = true  // Показать предупреждение
                        case .failure(let error):
                            print("Failed to save order: \(error)")
                            showingAlert = true  // Показать предупреждение с ошибкой
                        }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Замовлення"),
                message: Text("Ваше замовлення прийнято!"),
                dismissButton: .default(Text("ОК"))
            )
        }
        
        
    }
}



struct CartDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        CartDetailPage()
    }
}


enum PaymentOption: String, CaseIterable {
    case pickup = "Картою при отримані"
    case delivery = "Готівкою"
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

struct CustomTextField: View {
    @Binding var text: String
    var hint: String
    var leadingIcon: Image
    var isPhone: Bool = false
    @State var isPasswordVisible: Bool = false // новое состояние
    var isPassword: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    
    var body: some View {
        HStack(spacing: -10) {
            Button(action: {
                // только для поля пароля
                if isPassword {
                    isPasswordVisible.toggle()
                }
            }) {
                // Если это поле пароля и пароль виден, показать иконку 'lock.open'
                // В противном случае показать переданную иконку
                if isPassword && isPasswordVisible {
                    Image(systemName: "lock.open")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .frame(width: 40, alignment: .leading)
                } else {
                    leadingIcon
                        .font(.callout)
                        .foregroundColor(.gray)
                        .frame(width: 40, alignment: .leading)
                }
            }
            
            if isPhone {
                iPhoneNumberField(hint, text: $text)
                    .flagHidden(true)
                    .prefixHidden(false)
            } else if isPassword {
                if isPasswordVisible {
                    TextField(hint, text: $text)
                        .keyboardType(keyboardType)
                        .autocapitalization(autocapitalization)
                } else {
                    SecureField(hint, text: $text)
                        .keyboardType(keyboardType)
                        .autocapitalization(autocapitalization)
                }
            } else {
                TextField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalization)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.1))
        }
    }
}


//struct CustomTextField: View {
//    @Binding var text: String
//    var hint: String
//    var leadingIcon: Image
//    var isPhone: Bool = false
//    var isPassword: Bool = false
//    var keyboardType: UIKeyboardType = .default
//    var autocapitalization: UITextAutocapitalizationType = .sentences
//
//    var body: some View {
//        HStack(spacing: -10) {
//            leadingIcon
//                .font(.callout)
//                .foregroundColor(.gray)
//                .frame(width: 40, alignment: .leading)
//
//            if isPhone {
//                iPhoneNumberField(hint, text: $text)
//                    .flagHidden(true)
//                    .prefixHidden(false)
//            }  else if isPassword {
//                SecureField(hint, text: $text)
//                    .keyboardType(keyboardType)
//                    .autocapitalization(autocapitalization)
//            } else {
//                TextField(hint, text: $text)
//                    .keyboardType(keyboardType)
//                    .autocapitalization(autocapitalization)
//            }
//        }
//        .padding(.horizontal, 15)
//        .padding(.vertical, 15)
//        .background {
//            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                .fill(Color.gray.opacity(0.1))
//        }
//    }
//}

