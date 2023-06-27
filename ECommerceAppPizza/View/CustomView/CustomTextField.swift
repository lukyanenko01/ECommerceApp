//
//  CustomTextField.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI
import iPhoneNumberField

struct CustomTextField: View {
    @Binding var text: String
    var hint: String
    var leadingIcon: Image
    var isPhone: Bool = false
    @State var isPasswordVisible: Bool = false
    var isPassword: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    
    var body: some View {
        HStack(spacing: -10) {
            Button(action: {
                if isPassword {
                    isPasswordVisible.toggle()
                }
            }) {
               
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
