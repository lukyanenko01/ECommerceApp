//
//  Position.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 12.06.2023.
//

import Foundation
import FirebaseFirestore

struct Position {
    var id: String
    var title: String
    var price: Int
    var size: String
    var count: Int
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["title"] = title
        repres["price"] = price
        repres["size"] = size
        repres["count"] = count
        return repres
    }
    
    init(id: String, title: String, price: Int, size: String, count: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.size = size
        self.count = count
    }


    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let title = data["title"] as? String,
              let price = data["price"] as? Int,
              let size = data["size"] as? String,
              let count = data["count"] as? Int else { return nil }
        
        self.id = id
        self.title = title
        self.price = price
        self.size = size
        self.count = count
    }
}

