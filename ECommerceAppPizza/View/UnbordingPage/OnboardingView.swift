//
//  OnboardingView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var activeIntro: PageIntro = pageIntros[0]
    @State private var currentIndex: Int = 0
    let onComplete: () -> Void

    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            IntroView(intro: $activeIntro, currentIndex: $currentIndex, size: size) {
                VStack(spacing: 10) {
                                
                    Button {
                        if currentIndex == pageIntros.count - 1 {
                            onComplete()
                        } else {
                            currentIndex += 1
                            activeIntro = pageIntros[currentIndex]
                        }
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
                        if currentIndex == pageIntros.count - 1 {
                            AppRouter.switchRootView(to: AuthView().preferredColorScheme(.light))
                            onComplete()
                        } else {
                            currentIndex += 1
                            activeIntro = pageIntros[currentIndex]
                        }
                    } label: {
                        Text("Реєстрація" )
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color("ColorBT"))

                            }
                    }
                                        
                    Button {
                        if let url = URL(string: "https://pizza-website-vert.vercel.app/privacy") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Privacy Policy")
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




//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView {}
//    }
//}
