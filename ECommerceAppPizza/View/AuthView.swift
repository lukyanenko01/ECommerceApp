//
//  AuthView.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 21.06.2023.
//

import SwiftUI

struct AuthView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var currentPassword = ""
    
    @State private var isAuth = true
    @State private var isPasswordVisible = false
    @State private var isCurrentPasswordVisible = false
    
    @State private var isTabViewShow = false
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader {
            let size = $0.size

            VStack(spacing: 10) {
                GeometryReader {
                    let size = $0.size
                    Image("auth")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .frame(width: size.width, height: size.height)
                }
                Text(isAuth ? "Авторизація" : "Реєстрація")
                    .font(.custom(customFont, size: isAuth ? 40 : 30).bold())

                    .foregroundColor(.orange)
                    .padding(.bottom, 30)
                

                CustomTextField(text: $email, hint: "email", leadingIcon: Image(systemName: "envelope"), keyboardType: .emailAddress, autocapitalization: .none)
                CustomTextField(text: $password, hint: "Пароль", leadingIcon: Image(systemName: "lock"), isPassword: true)
                
                if !isAuth {
                    CustomTextField(text: $currentPassword, hint: "Повторити пароль", leadingIcon: Image(systemName: "lock"), isPassword: true)
                }
                
                Spacer(minLength: 10)
                
                Button {
                    if isAuth {
                        
                        AuthService.shared.signIn(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))

                            case .failure(let error):
                                alertMessage = "Помилка авторизації: \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                        
                    } else {
                        
                        guard password == currentPassword else {
                            self.alertMessage =  "Паролі не збігаються"
                            self.isShowAlert.toggle()
                            return
                        }
                        
                        AuthService.shared.singUp(name: "", email: self.email, password: self.password) { result in
                            switch result {
                                
                            case .success(let user):
                                alertMessage = "Успішна авторизація \(user.email ?? "")"
                               // self.isShowAlert.toggle()
                                
                                self.email = ""
                                self.password = ""
                                self.currentPassword = ""
                                //self.isAuth.toggle()
                                AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))

                            case .failure(let error):
                                alertMessage = "Помилка реєстрації - \(error.localizedDescription)"
                                self.isShowAlert.toggle()
                            }
                        }
                        
                        
                    }
                } label: {
                    Text(isAuth ? "Увійти" : "Створити профіль")
                        .font(.custom(customFont, size: 18))
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
                    isAuth.toggle()
                } label: {
                    Text(isAuth ? "Реєстрація" : "Повернутися")
                        .font(.custom(customFont, size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(Color("BG"))
                            
                        }
                }
                
                if isAuth {
                    Button {
                        AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))
                    } label: {
                        Text("Вхід без реєстрації")
                            .font(.custom(customFont, size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color("BG"))
                                
                            }
                    }
                }
                Button(action: {
                    if let url = URL(string: "https://belok.ua") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Privacy Policy")
                        .font(.custom(customFont, size: 16))
                        .fontWeight(.semibold)
                        .underline()
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 25)
        }
                
        .padding(15)
        .alert(alertMessage, isPresented: $isShowAlert) {
            Button { } label: {
                Text("OK")
            }
            
        }
        .animation(Animation.easeIn(duration: 0.2), value: isAuth)
        .preferredColorScheme(.light)

    }
    

}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
