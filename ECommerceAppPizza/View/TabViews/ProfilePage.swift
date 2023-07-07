//
//  ProfilePage.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI

struct ProfilePage: View {
    
    @State var name = "Тут буде ваше ім'я"
    @State var adress = "Тут буде ваша адреса"

    
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
                                        Button {
                                            AppRouter.switchRootView(to: AuthView().preferredColorScheme(.light))
                                        } label: {
                                            Text("Залогінитися")
                                                .font(.custom(customFont, size: 18).bold())
                                                .foregroundColor(.white)
                                                .padding(.vertical,18)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.orange)
                                                .cornerRadius(15)
                                                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                                        }
                                    }
                                    .padding(.horizontal,25)
                                }
                            } else {
                                Text(name)
                                    .font(.custom(customFont, size: 16))
                                    .fontWeight(.semibold)
                                    .padding(.top,15)
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "location.north.circle.fill")
                                        .foregroundColor(.gray)
                                        .rotationEffect(.init(degrees: 180))
                                    Text(adress)
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
                                SettingProfile()
                                    .navigationTitle("Налаштування профілю")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("HomeBG").ignoresSafeArea())
                                
                            }
                        }
                        if AuthService.shared.currentUser != nil  {
                            CustomNavigationLink(title: "Історія замовлень") {
                                HistoruOrders()
                                    .navigationTitle("Історія замовлень")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("HomeBG").ignoresSafeArea())
                                
                            }
                        }
                        
                        CustomNavigationLink(title: "Зв'язатися з нами") {
                            ContactsView()
                                .navigationTitle("Зв'язатися з нами")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("HomeBG").ignoresSafeArea())
                                
                        }
                        
                        CustomButton(title: "Developer", url: URL(string: "https://www.linkedin.com/in/vladimir-lukyanenko-03054a199/")!)

                        CustomButton(title: "Privacy Policy", url: URL(string: "https://pizza-website-vert.vercel.app/privacy")!)
                        
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
            .onAppear(perform: loadProfile)

            
        }
    }
    
    func loadProfile() {
        if AuthService.shared.currentUser != nil {
            AuthService.shared.dataBaseService.getProfile { result in
                switch result {
                case .success(let profile):
                    self.name = profile.name.isEmpty ? "Тут буде ваше ім'я" : profile.name
                    self.adress = profile.adress.isEmpty ? "Тут буде ваша адреса" : profile.adress
                case .failure(let error):
                    print("Failed to load profile: \(error)")
                }
            }
        }
    }



    
    @ViewBuilder
    func CustomButton(title: String, url: URL) -> some View {
        Button {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Text(title)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)

                Spacer()

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

//struct ProfilePage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePage()
//    }
//}
