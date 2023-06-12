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
        var total: Int = 0
        
        cartProducts.forEach { product in
            var price = 0
            switch product.size {
            case "S":
                price = product.priceS
            case "M":
                price = product.priceM
            case "Xl":
                price = product.priceXl
            default:
                break
            }
            
            total += price * product.quantity
        }
        
        return ("\(total) грн")
    }

}

