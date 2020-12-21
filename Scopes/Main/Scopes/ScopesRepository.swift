//
//  ScopesRepository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 17/12/20.
//

import Foundation
import Firebase

struct FirestoreScopesRepository: FirestoreRepository {
    typealias Element = Scope
    
    let database = Firestore.firestore()
    var collection: CollectionReference {
        database.collection("scopes")
    }
}

struct Scope: Codable {
    var title: String
}
