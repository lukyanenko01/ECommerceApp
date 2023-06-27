//
//  ProfileViewModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 23.06.2023.
//

import SwiftUI

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
