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
    @State private var name = ""
    
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
                    Image("unboarding3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                        .frame(width: size.width, height: size.height)
                }
                Text(isAuth ? "Autorización" : "Inscripción")
                    .font(.system(size: isAuth ? 40 : 30).bold())
                    .foregroundColor(Color("ButtonCalculator"))
                    .padding(.bottom, 30)
                
                if !isAuth {
                    CustomTextField(text: $name, hint: "Nombre", leadingIcon: Image(systemName: "person"))
                }
                CustomTextField(text: $email, hint: "Correo electrónico", leadingIcon: Image(systemName: "envelope"), keyboardType: .emailAddress, autocapitalization: .none)
                CustomTextField(text: $password, hint: "Repetir contraseña", leadingIcon: Image(systemName: "lock"), isPassword: true)
                
                if !isAuth {
                    CustomTextField(text: $currentPassword, hint: "Contraseña", leadingIcon: Image(systemName: "lock"), isPassword: true)
                }
                
                Spacer(minLength: 10)
                
                Button {
                    if isAuth {
                        
                        AuthService.shared.signIn(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))

                            case .failure(let error):
                                alertMessage = "Error de autorización \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                        
                    } else {
                        
                        guard !name.isEmpty, password == currentPassword else {
                            self.alertMessage = name.isEmpty ? "El nombre es obligatorio" : "Las contraseñas no coinciden"
                            self.isShowAlert.toggle()
                            return
                        }
                        
                        AuthService.shared.singUp(name: self.name, email: self.email, password: self.password) { result in
                            switch result {
                                
                            case .success(let user):
                                alertMessage = "Ponte al día con el correo electrónico \(user.email ?? "")"
                               // self.isShowAlert.toggle()
                                
                                self.email = ""
                                self.password = ""
                                self.currentPassword = ""
                                self.name = ""
                                //self.isAuth.toggle()
                                AppRouter.switchRootView(to: MainPage().preferredColorScheme(.light))

                            case .failure(let error):
                                alertMessage = "Error de registro - \(error.localizedDescription)"
                                self.isShowAlert.toggle()
                            }
                        }
                        
                        
                    }
                } label: {
                    Text(isAuth ? "Conectarse" : "Crear perfil")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(Color("BG"))
                            
                        }
                }
                
                Button {
                    isAuth.toggle()
                } label: {
                    Text(isAuth ? "Inscripción" : "Volver")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(Color("BG"))
                            
                        }
                }
                Button(action: {
                    if let url = URL(string: "https://belok.ua") {
                        UIApplication.shared.open(url)
                    }
                }) {
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
