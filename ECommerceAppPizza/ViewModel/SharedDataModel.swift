//
//  SharedDataModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 07.06.2023.
//

import SwiftUI

class SharedDataModel: ObservableObject {
    
    let dataBaseService = DataBaseService()
    @Published var detailProduct: Products?
    @Published var showDetailProduct: Bool = false
    @Published var fromSearchPage: Bool = false
    @Published var likedProducts: [Products] = []
    @Published var cartProducts: [Products] = []
    
    init() {
        if AuthService.shared.currentUser != nil {
            loadLikedProducts()
        }
    }
    
    private func loadLikedProducts() {
        dataBaseService.getFavoriteProductsForUser(userId: AuthService.shared.currentUser!.uid) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.likedProducts = products
                }
            case .failure(let error):
                print("Failed to load favorite products: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLikedProduct(_ product: Products) {
        if let index = likedProducts.firstIndex(where: { $0.id == product.id }) {
            likedProducts.remove(at: index)
            dataBaseService.removeFromFavorites(product: product, userId: AuthService.shared.currentUser!.uid) { result in
                switch result {
                case .success():
                    print("Product removed from favorites successfully.")
                case .failure(let error):
                    print("Failed to remove product from favorites: \(error.localizedDescription)")
                }
            }
        } else {
            likedProducts.append(product)
            dataBaseService.saveToFavorites(product: product, userId: AuthService.shared.currentUser!.uid) { result in
                switch result {
                case .success():
                    print("Product added to favorites successfully.")
                case .failure(let error):
                    print("Failed to add product to favorites: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // calculation Total price...
    func getTotalPrice() -> String {
        var total: Double = 0.0
        
        for product in cartProducts {
            var productTotal = product.priceS * product.quantity
            if product.size == "M" {
                productTotal = product.priceM * product.quantity
            } else if product.size == "XL" {
                productTotal = product.priceXl * product.quantity
            }
            
            // добавить стоимость сырного борта, если есть
            if product.cheeseCrust {
                if product.size == "S" {
                    productTotal += product.cheeseS * product.quantity
                } else if product.size == "M" {
                    productTotal += product.cheeseM * product.quantity
                } else if product.size == "XL" {
                    productTotal += product.cheeseXl * product.quantity
                }
            }
            
            total += Double(productTotal)
        }

        return String(format: "%.2f", total)
    }

    
    func confirmOrder(name: String, location: String, phone: String, delivery: Int, selectedPaymentOption: PaymentOption?, completion: @escaping (Result<Void, Error>) -> Void) {
        let positions = self.cartProducts.map {
            var price = 0
            switch $0.size {
            case "S":
                price = $0.priceS
            case "M":
                price = $0.priceM
            case "Xl":
                price = $0.priceXl
            default:
                break
            }
            return Position(id: $0.id, title: $0.title, price: price, size: $0.size, count: $0.quantity)
        }

         let order = Order(userName: name,
                           location: location,
                           positions: positions,
                           date: Date(),
                           status: "New",
                           number: phone,
                           cost: getTotalPrice(),
                           delivery: delivery == 0 ? "З собою" : "Доставка",
                           pay: selectedPaymentOption?.rawValue ?? "")

         dataBaseService.saveOrder(order: order) { result in
             switch result {
             case .success(_):
                 self.cartProducts.removeAll() // Очистить корзину
                 completion(.success(()))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
        
        guard let user = AuthService.shared.currentUser else {
            print("No user is signed in.")
            return
        }
        
        if let user = AuthService.shared.currentUser {
            dataBaseService.saveOrderForUser(order: order, userId: user.uid) { result in
                switch result {
                case .success:
                    print("Order saved successfully.")
                case .failure(let error):
                    print("Failed to save order: \(error.localizedDescription)")
                }
            }
        } else {
            print("No user is signed in.")
        }
    }


}

