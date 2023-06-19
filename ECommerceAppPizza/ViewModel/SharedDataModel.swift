//
//  SharedDataModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 07.06.2023.
//

import SwiftUI

class SharedDataModel: ObservableObject {
    
    let dataBaseService = DataBaseService()

    // Detail Product Data...
    @Published var detailProduct: Products?
    @Published var showDetailProduct: Bool = false
    
    // Matched Geometry Effect from Search page
    @Published var fromSearchPage: Bool = false
    
    // Like Products...
    @Published var likedProducts: [Products] = []
    
    // Basket Products...
    @Published var cartProducts: [Products] = []
    
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
    }


}

