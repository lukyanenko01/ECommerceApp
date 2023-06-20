//
//  UnboardingView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import SwiftUI

struct UnboardingView: View {
    
    @State private var activeIntro: PageIntro = pageIntros[0]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            IntroView(intro: $activeIntro, size: size) {
                VStack(spacing: 10) {
                                
                    Button {
                        AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))

                    } label: {
                        Text("Далі" )
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color.orange)

                            }
                    }
                                        
                    Button {
                        if let url = URL(string: "https://belok.ua") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Política de privacidad")
                            .fontWeight(.semibold)
                            .underline()
                            .foregroundColor(.blue)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 25)
               
            }
        }
        .padding(15)

    }
}




