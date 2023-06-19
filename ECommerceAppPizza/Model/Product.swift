//
//  Product.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 06.06.2023.
//

import SwiftUI
import Firebase

enum ProductType: String, CaseIterable {
case Pizza = "Піца"
case Sous = "Соуси"
case Other = "Інше"
//case Tablets = "Tablets"
    
}


struct Products: Identifiable, Hashable {
    var id = UUID().uuidString
    var type: ProductType.RawValue
    var title: String
    var description: String = ""
    var priceS: Int
    var priceM: Int
    var priceXl: Int
    var productImage: String = ""
    var size: String
    var quantity: Int = 1
    var cheeseS: Int = 0
    var cheeseM: Int
    var cheeseXl: Int
    var cheeseCrust: Bool = false

    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["type"] = self.type
        repres["title"] = self.title
        repres["priceS"] = self.priceS
        repres["priceM"] = self.priceM
        repres["priceXl"] = self.priceXl
        repres["description"] = self.description
        repres["productImage"] = self.productImage
        repres["size"] = self.size
        repres["quantity"] = self.quantity
        repres["cheeseS"] = self.cheeseS
        repres["cheeseM"] = self.cheeseM
        repres["cheeseXl"] = self.cheeseXl
        repres["cheeseCrust"] = self.cheeseCrust


        return repres
    }
    
    internal init(id: String = UUID().uuidString,
                  title: String,
                  type: ProductType.RawValue,
                  productImage: String = "",
                  priceS: Int,
                  priceM: Int,
                  priceXl: Int,
                  description: String,
                  size: String,
                  quantity: Int,
                  cheeseS: Int,
                  cheeseM: Int,
                  cheeseXl: Int,
                  cheeseCrust: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.productImage = productImage
        self.priceS = priceS
        self.priceM = priceM
        self.priceXl = priceXl
        self.description = description
        self.size = size
        self.quantity = quantity
        self.cheeseS = cheeseS
        self.cheeseM = cheeseM
        self.cheeseXl = cheeseXl
        self.cheeseCrust = cheeseCrust

    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let type = data["type"] as? String else { return nil }
        guard let priceS = data["priceS"] as? Int else { return nil }
        guard let priceM = data["priceM"] as? Int else { return nil }
        guard let priceXl = data["priceXl"] as? Int else { return nil }
        guard let description = data["description"] as? String else { return nil }
        guard let productImage = data["productImage"] as? String else { return nil }
        guard let size = data["size"] as? String else { return nil }
        guard let quantity = data["quantity"] as? Int else { return nil }
        guard let cheeseS = data["cheeseS"] as? Int else { return nil }
        guard let cheeseM = data["cheeseM"] as? Int else { return nil }
        guard let cheeseXl = data["cheeseXl"] as? Int else { return nil }
        guard let cheeseCrust = data["cheeseCrust"] as? Bool else { return nil }


        
        self.id = id
        self.title = title
        self.type = type
        self.priceS = priceS
        self.priceM = priceM
        self.priceXl = priceXl
        self.description = description
        self.productImage = productImage
        self.size = size
        self.quantity = quantity
        self.cheeseS = cheeseS
        self.cheeseM = cheeseM
        self.cheeseXl = cheeseXl
        self.cheeseCrust = cheeseCrust


    }
}



