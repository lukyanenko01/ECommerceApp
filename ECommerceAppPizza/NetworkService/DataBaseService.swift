//
//  DataBaseService.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 08.06.2023.
//

import Foundation
import FirebaseFirestore

class DataBaseService {
    
    private let db: Firestore
    
    init(firestore: Firestore = .firestore()) {
        self.db = firestore
    }
    

    
    var productsRef: CollectionReference {
        return db.collection("products")
    }
    
    var orderRef: CollectionReference {
        return db.collection("order")
    }
    
    func getProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        productsRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            let products = querySnapshot.documents.compactMap { Products(doc: $0) }
            completion(.success(products))
        }
    }
    
    func saveOrder(order: Order, completion: @escaping (Result<Void, Error>) -> Void) {
        var orderData = order.representation
        orderData["positions"] = order.positions.map { $0.representation }
        orderRef.addDocument(data: orderData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


    
}
