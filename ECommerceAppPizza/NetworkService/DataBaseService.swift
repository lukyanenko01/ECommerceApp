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
    
    
}
