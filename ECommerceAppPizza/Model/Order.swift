//
//  Order.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 12.06.2023.
//

import Foundation
import FirebaseFirestore

struct Order: Identifiable {
    
    var id: String
    var userName: String
    var location: String
    var positions = [Position]()
    var date: Date
    var status: String
    var number: String
    var cost: String
    var delivery: String
    var pay: String
    var comment: String

        
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userName"] = userName
        repres["location"] = location
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        repres["number"] = number
        repres["cost"] = cost
        repres["delivery"] = delivery
        repres["pay"] = pay
        repres["comment"] = comment
        repres["positions"] = positions.map { $0.representation }
        return repres
    }
    
    init(id: String = UUID().uuidString,
         userName: String,
         location: String,
         positions: [Position] = [Position](),
         date: Date,
         status: String,
         number: String,
         cost: String,
         delivery: String,
         pay: String, comment: String) {
        
        self.id = id
        self.userName = userName
        self.location = location
        self.positions = positions
        self.date = date
        self.status = status
        self.number = number
        self.cost = cost
        self.delivery = delivery
        self.pay = pay
        self.comment = comment

    }
    
    init?(doc: QueryDocumentSnapshot) {
        
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let userName = data["userName"] as? String else { return nil }
        guard let location = data["location"] as? String else { return nil }
        guard let date = data["date"] as? Timestamp else { return nil }
        guard let status = data["status"] as? String else { return nil }
        guard let number = data["number"] as? String else { return nil }
        guard let cost = data["cost"] as? String else { return nil }
        guard let delivery = data["delivery"] as? String else { return nil }
        guard let pay = data["pay"] as? String else { return nil }
        guard let comment = data["comment"] as? String else { return nil }
        guard let positionsData = data["positions"] as? [[String: Any]] else { return nil }

        self.id = id
        self.userName = userName
        self.location = location
        self.date = date.dateValue()
        self.status = status
        self.number = number
        self.cost = cost
        self.delivery = delivery
        self.pay = pay
        self.comment = comment
        self.positions = positionsData.compactMap { Position(data: $0) }

    }
    
}
