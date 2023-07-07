//
//  OrangeToggleStyle.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI

struct OrangeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(configuration.isOn ? Color.orange : Color.gray)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

