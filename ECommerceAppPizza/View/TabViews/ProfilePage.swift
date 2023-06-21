//
//  ProfilePage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI

struct ProfilePage: View {
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("Профіль")
                            .font(.custom(customFont, size: 28).bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 15) {
                            if AuthService.shared.currentUser == nil  {
                                VStack {
                                    Text("Щоб мати змогу керувати профілем та відслідковувати історію замовлень, будьласка зареєструйтеся в додатку або верифікуйтеся")
                                        .font(.custom(customFont, size: 18))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                        .padding(.top,10)
                                        .multilineTextAlignment(.center)
                                    
                                    Group {
                                        NavigationLink(destination: AuthView()) {
                                            Text("Увійти")
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
                            } else {
                                Text("Rosiana Doe")
                                    .font(.custom(customFont, size: 16))
                                    .fontWeight(.semibold)
                                    .padding(.top,15)
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "location.north.circle.fill")
                                        .foregroundColor(.gray)
                                        .rotationEffect(.init(degrees: 180))
                                    Text("адресса доставки: вул. Перемоги України 129")
                                        .font(.custom(customFont, size: 15))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding([.horizontal, .bottom])
                        .background(
                            Color.white
                                .cornerRadius(12)
                        )
                        .padding()
                        .padding(.top, 40)
                        
                        // Custom Navigation Links...
                        if AuthService.shared.currentUser != nil  {
                            CustomNavigationLink(title: "Налаштування профілю") {
                                Text("")
                                    .navigationTitle("Налаштування профілю")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("HomeBG").ignoresSafeArea())
                                
                            }
                        }
                        
                        CustomNavigationLink(title: "Зв'язатися з нами") {
                            Text("")
                                .navigationTitle("Адреса доставки")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("HomeBG").ignoresSafeArea())
                                
                        }
                        
                        if AuthService.shared.currentUser != nil  {
                            CustomNavigationLink(title: "Історія замовлень") {
                                Text("")
                                    .navigationTitle("Історія замовлень")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("HomeBG").ignoresSafeArea())
                                
                            }
                        }
                        
                        CustomNavigationLink(title: "Залишити відгук") {
                            Text("")
                                .navigationTitle("Налаштування профілю")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("HomeBG").ignoresSafeArea())
                        }
                        
                        CustomNavigationLink(title: "Розробник додатків") {
                            Text("")
                                .navigationTitle("Налаштування профілю")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("HomeBG").ignoresSafeArea())
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical,20)
                
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("HomeBG")
                    .ignoresSafeArea()
            )
            
        }
    }
    
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String, @ViewBuilder content: @escaping () -> Detail) -> some View {
        
        NavigationLink {
            content()
        } label: {
            
            HStack {
                Text(title)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(
            
                Color.white
                    .cornerRadius(12)
                
            )
            .padding(.horizontal)
            .padding(.top,10)
            
        }

    }
    
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
