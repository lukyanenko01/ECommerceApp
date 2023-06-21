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
    
    private var usersRef: CollectionReference {
        return db.collection("Users")
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

    func setProfile(user: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }

    func getProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        usersRef.document(AuthService.shared.currentUser!.uid).getDocument { docSnapsot, error in
            guard let snap = docSnapsot else { return }
            guard let data = snap.data() else { return }
            guard let userName = data["name"] as? String else { return }
            guard let email = data["email"] as? String else { return }
            guard let id = data["id"] as? String else { return }

            let profile = Profile(id: id, name: userName, email: email)

            completion(.success(profile))

        }
    }

    func saveToFavorites(product: Products, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let favoriteProductRef = usersRef.document(userId).collection("favorites").document(product.id)

        favoriteProductRef.setData(product.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func removeFromFavorites(product: Products, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        usersRef.document(userId).collection("favorites").document(product.id).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getFavoriteProductsForUser(userId: String, completion: @escaping (Result<[Products], Error>) -> Void) {
        usersRef.document(userId).collection("favorites").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            let products = querySnapshot.documents.compactMap { Products(doc: $0) }
            completion(.success(products))
        }
    }

    
}
