//
//  AuthService.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    let dataBaseService = DataBaseService()
    
    private init() { }
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    var currentUserEmail: String?
    
    func singUp(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            
            if let result = result {
                
                let profile = Profile(id: result.user.uid,
                                      name: name,
                                      email: email, phone: "", adress: "")
                self.dataBaseService.setProfile(user: profile) { resultdb in
                    switch resultdb {
                        
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
                self.currentUserEmail = email
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            throw signOutError
        }
    }
    
    func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No current user found"])))
            return
        }
        
        user.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
}

