//
//  CustomTextFieldProfile.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI

struct CustomTextFieldProfile: View {
    
    @Binding var text: String
    var hint: String
    @Binding var isEditting: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(hint)
                .font(.custom(customFont, size: 20))
                .foregroundColor(.gray)
            if !isEditting {
                Text(text)
                    .font(.custom(customFont, size: 22).bold())
            } else {
                TextField(hint, text: $text)
                    .padding(7)
                    .background(Color.white)
                    .cornerRadius(7)
            }
            Divider()
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.1))
        }
    }
    
}

