//
//  GoalsRepository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 17/12/20.
//

import Foundation
import Firebase

struct FirestoreGoalsRepository: FirestoreRepository {
    typealias Element = Goal
    
    let parent: IdentifiableItem<Scope>
    let database = Firestore.firestore()
    var collection: CollectionReference {
        database.document(parent.path).collection("goals")
    }
}

struct Goal: Codable {
    var title: String
    private var dueDateTimestamp: Timestamp
    var dueDate: Date {
        get { dueDateTimestamp.dateValue() }
        set { dueDateTimestamp = Timestamp(date: newValue) }
    }
    
    init(title: String, dueDate: Date) {
        self.title = title
        self.dueDateTimestamp = Timestamp(date: dueDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, dueDateTimestamp = "dueDate"
    }
}
