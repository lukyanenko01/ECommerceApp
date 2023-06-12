//
//  CartDetailPage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 12.06.2023.
//

import SwiftUI

struct CartDetailPage: View {
    
    @State var selectedPaymentOption: PaymentOption?
    @State var delivery = 0
    
    @State private var name = ""
    @State private var phone = ""
    @State private var location = ""
    
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
                        Text("Спосіб отримання")
                            .font(.custom(customFont, size: 20).bold())
                        RadioButtonGroup(selectedOption: $selectedPaymentOption)
                        
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("Дані для замовлення")
                            .font(.custom(customFont, size: 20).bold())
                        
                        CustomTextField(text: $name, hint: "Ім'я", leadingIcon: Image(systemName: "person"))
                        CustomTextField(text: $phone, hint: "Телефон", leadingIcon: Image(systemName: "phone"))
                        
                        if delivery == 1 {
                            CustomTextField(text: $location, hint: "Адреса доставки", leadingIcon: Image(systemName: "location"))
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
                    
                    Text("409 грн")
                        .font(.custom(customFont, size: 18).bold())
                        .foregroundColor(.orange)
                }
                
                
                
                Button {
                    
                    
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
    var isPassword: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    
    var body: some View {
        HStack(spacing: -10) {
            leadingIcon
                .font(.callout)
                .foregroundColor(.gray)
                .frame(width: 40, alignment: .leading)
            
            if isPassword {
                SecureField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalization)
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
