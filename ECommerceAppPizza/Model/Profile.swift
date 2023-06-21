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
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        
        repres["id"] = self.id
        repres["name"] = self.name
        repres["email"] = self.email

        return repres
    }
    
    internal init(id: String,
                  name: String,
                  email: String
                 ) {
        self.id = id
        self.name = name
        self.email = email

    }
    
}
