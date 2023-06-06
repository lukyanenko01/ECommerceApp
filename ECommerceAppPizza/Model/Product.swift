//
//  Product.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    var id = UUID().uuidString
    var type: ProductType
    var title: String
    var subtitle: String
    var description: String = ""
    var price: String
    var productImage: String = ""
    var quantity: Int = 1
}

enum ProductType: String, CaseIterable {
    
case Wearable = "Wearable"
case Laprops = "Laprops"
case Phones = "Phones"
case Tablets = "Tablets"
    
}
