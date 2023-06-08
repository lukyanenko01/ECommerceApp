//
//  SharedDataModel.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 07.06.2023.
//

import SwiftUI

class SharedDataModel: ObservableObject {

    // Detail Product Data...
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    // Matched Geometry Effect from Search page
    @Published var fromSearchPage: Bool = false
    
    // Like Products...
    @Published var likedProducts: [Product] = []
    
    // Basket Products...
    @Published var cartProducts: [Product] = []
    
    // calculation Total price...
    func getTotalPrice() -> String {
        
        var total: Int = 0
        
        cartProducts.forEach { product in
            let price = product.price.replacingOccurrences(of: "$", with: "") as NSString
            let quantity = product.quantity
            let priceTotal = quantity * price.integerValue
        
        total += priceTotal
        
        }
        return ("$\(total)")
    }

}

