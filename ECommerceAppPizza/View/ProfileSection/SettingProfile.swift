//
//  SettingProfile.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 22.06.2023.
//

import SwiftUI

struct SettingProfile: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    @State var name = "n/a"
    @State var email = "n/a"
    @State var phone = "n/a"
    @State var adress = "n/a"
    @State var password: String = ""

    
    @State var isEditting = false
    @State private var showingDeleteAccountConfirmationDialog = false
    @State private var showingPasswordInputView = false

    
    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    VStack {
                        CustomTextFieldProfile(text: $name, hint: "Ім'я", isEditting: $isEditting)
                        CustomTextFieldProfile(text: $phone, hint: "Телефон", isEditting: $isEditting)
                        CustomTextFieldProfile(text: $adress, hint: "Адреса доставки", isEditting: $isEditting)
                        
                    }
                    
                    
                    Button {
                        isEditting.toggle()
                        if !isEditting { // Если режим редактирования отключен, сохраните данные
                            AuthService.shared.updateProfile(name: self.name, email: self.email, phone: self.phone, adress: self.adress) { result in
                                switch result {
                                case .success(let user):
                                    print("User \(String(describing: user.email)) updated successfully.")
                                case .failure(let error):
                                    print("Failed to update user: \(error.localizedDescription)")
                                }
                            }
                        }
                    } label: {
                        Text(!isEditting ? "Редагувати" : "Зберегти")
                            .font(.custom(customFont, size: 18))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    .padding(10)
                    .background(!isEditting ? Color.orange : Color.green)
                    .cornerRadius(7)
                    .padding(.top,70)
                    
                    
                    
                    
                    
                }
                
            }
            Spacer()
            
            HStack {
                Button {
                    showingDeleteAccountConfirmationDialog = true
                } label: {
                    Text("Видалити аккаунт")
                        .font(.custom(customFont, size: 18))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(7)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .animation(Animation.easeIn(duration: 0.3), value: isEditting)
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showingPasswordInputView) {
            PasswordInputView(password: $password) {
                self.reauthenticateAndDeleteUser()
                showingPasswordInputView = false
            }
        }
         .confirmationDialog("Ви впевнені, що хочете видалити свій аккаунт?", isPresented: $showingDeleteAccountConfirmationDialog, actions: {
             Button("Видалити", role: .destructive) {
                 showingPasswordInputView = true
             }
             Button("Скасувати", role: .cancel) { }
         })
         .onAppear(perform: loadProfile)
         .dismissKeyboardOnTap()

    }
    
    func reauthenticateAndDeleteUser() {
        guard let email = AuthService.shared.currentUser?.email else { return }
        
        AuthService.shared.reauthenticateUser(email: email, password: password) { result in
            switch result {
            case .success:
                deleteUser()
            case .failure(let error):
                print("Failed to reauthenticate user: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteUser() {
          AuthService.shared.deleteUser { result in
              switch result {
              case .success:
                  print("User deleted successfully.")
                  AppRouter.switchRootView(to: AuthView().preferredColorScheme(.light))
              case .failure(let error):
                  print("Failed to delete user: \(error.localizedDescription)")
              }
          }
      }
      
    
    func loadProfile() {
        AuthService.shared.dataBaseService.getProfile { result in
            switch result {
            case .success(let profile):
                self.name = profile.name
                self.email = profile.email
                self.phone = profile.phone
                self.adress = profile.adress
            case .failure(let error):
                print("Failed to load profile: \(error)")
            }
        }
    }
    
}


struct SettingProfile_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfile()
    }
}


struct PasswordInputView: View {
    @Binding var password: String
    var onSubmit: () -> Void
    
    var body: some View {
        VStack {
            SecureField("Пароль", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Подтвердить") {
                onSubmit()
            }
        }
    }
}
