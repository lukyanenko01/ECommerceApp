//
//  EmptyFavoritesView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 21.06.2023.
//

import SwiftUI

struct EmptyFavoritesView: View {
    
    //var isForShow: Bool
    
    var body: some View {
        Group {
            Image("noLike")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .padding(.top,35)

            Text("Ще немає обраних")
                .font(.custom(customFont, size: 25))
                .fontWeight(.semibold)
            
            if AuthService.shared.currentUser == nil {
                Text("щоб мати змогу зберігати в улюблених продукти, будьласка зареєструйтеся в додатку або верифікуйтеся")
                    .font(.custom(customFont, size: 18))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top,10)
                    .multilineTextAlignment(.center)
            } else {
                Text("Натисніть кнопку \"Мені подобається\" на сторінці кожного продукту, щоб зберегти обрані.")
                    .font(.custom(customFont, size: 18))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top,10)
                    .multilineTextAlignment(.center)
            }
                
            
        }
    }
}
