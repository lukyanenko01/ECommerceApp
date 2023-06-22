//
//  Profile.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import Foundation

struct Profile: Identifiable {
    
    var id: String
    var name: String
    var email: String
    var phone: String
    var adress: String

    
    var representation: [String: Any] {
        var repres = [String: Any]()
        
        repres["id"] = self.id
        repres["name"] = self.name
        repres["email"] = self.email
        repres["phone"] = self.phone
        repres["adress"] = self.adress



        return repres
    }
    
    internal init(id: String,
                  name: String,
                  email: String,
                  phone: String,
                  adress: String
                 ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.adress = adress
    }
    
}
