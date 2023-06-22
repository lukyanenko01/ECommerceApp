//
//  SettingProfile.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 22.06.2023.
//

import SwiftUI

struct SettingProfile: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        //        ScrollView(.vertical, showsIndicators: false) {
        VStack {
            
            
            
            Button {
                
            } label: {
                Text("Редагувати")
                    .font(.custom(customFont, size: 18))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(10)
            .background(Color.orange)
            .cornerRadius(7)
            
            Spacer()
            
            HStack {
                Button {
                    
                } label: {
                    Text("Видалити аккаунт")
                        .font(.custom(customFont, size: 18))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(10)
                .background(Color.red)
                .cornerRadius(7)
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    viewModel.signOut()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title3)
                            .frame(width: 48, height: 48)
                            .foregroundColor(.red)
                        
                        Text("Вийти")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top,25)
        .frame(maxWidth: .infinity, alignment: .leading)
        //        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct SettingProfile_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfile()
    }
}

class ProfileViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private var authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
    }
    
    func signOut() {
        do {
            try authService.signOut()
            AppRouter.switchRootView(to: AuthView().preferredColorScheme(.light))
        } catch let signOutError as NSError {
            self.showingAlert = true
            self.alertMessage = "Error signing out: \(signOutError.localizedDescription)"
        }
    }
}


struct CustomProfileTextField: View {
    @Binding var text: String
    var hint: String
    var leadingIcon: Image
    var isPhone: Bool = false
    var isPassword: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    
    var body: some View {
        HStack(spacing: -10) {
            leadingIcon
                .font(.callout)
                .foregroundColor(.gray)
                .frame(width: 40, alignment: .leading)
            
            if isPassword {
                SecureField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalization)
            } else {
                TextField(hint, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalization)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.1))
        }
    }
}
