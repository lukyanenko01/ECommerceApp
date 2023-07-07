//
//  LikedPageViewModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 21.06.2023.
//

import SwiftUI

class LikedPageViewModel: ObservableObject {
    @Published var favoriteProducts: [Products] = []
    private let dataBaseService = DataBaseService()
    @Published var isLoading: Bool = false

    
    func fetchFavoriteProducts() {
        self.isLoading = true
        guard let userId = AuthService.shared.currentUser?.uid else {
            self.isLoading = false
            return
            
        }
        
        dataBaseService.getFavoriteProductsForUser(userId: userId) { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.favoriteProducts = products
                    self.isLoading = false
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func deleteProduct(product: Products) {
        guard let userId = AuthService.shared.currentUser?.uid else { return }
        
        dataBaseService.removeFromFavorites(product: product, userId: userId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self.favoriteProducts.firstIndex(where: { $0.id == product.id }) {
                        self.favoriteProducts.remove(at: index)
                    }
                }
            case .failure(let error):
                print("Failed to remove product from favorites: \(error)")
            }
        }
    }
}
