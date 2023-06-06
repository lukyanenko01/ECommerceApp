//
//  MoreProductsView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI

struct MoreProductsView: View {
    
    var body: some View {
        
        VStack {
            Text("Дивитися більше")
                .font(.custom(customFont, size: 24).bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("HomeBG").ignoresSafeArea())
    }
}

struct MoreProductsView_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsView()
    }
}
