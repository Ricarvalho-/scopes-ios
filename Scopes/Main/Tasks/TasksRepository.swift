//
//  TasksRepository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 17/12/20.
//

import Foundation
import Firebase

struct FirestoreTasksRepository: FirestoreRepository {
    typealias Element = Task
    
    let parent: IdentifiableItem<Goal>
    let database = Firestore.firestore()
    var collection: CollectionReference {
        database.document(parent.path).collection("tasks")
    }
}

struct Task: Codable, Hashable {
    var title: String
    var status: Status
    
    enum Status: Int, Codable {
        case toDo, doing, done
    }
}

extension Task.Status: Localizable {
    var localized: String {
        switch self {
        case .toDo: return Localized.Task.Status.toDo.localized
        case .doing: return Localized.Task.Status.doing.localized
        case .done: return Localized.Task.Status.done.localized
        }
    }
}

extension Task.Status: CommandProvider {
    var availableCommands: [Command] {
        switch self {
        case .toDo: return [Action(.begin)]
        case .doing: return [Action(.abort), Action(.finish)]
        case .done: return [Action(.remake)]
        }
    }
    
    mutating func perform(_ command: Command) {
        guard let action = command as? Action else { return }
        switch action.kind {
        case .begin: begin()
        case .abort: abort()
        case .finish: finish()
        case .remake: remake()
        }
    }
    
    private struct Action: Command {
        fileprivate let kind: Kind
        var title: Localizable {
            switch kind {
            case .begin: return Localized.Task.Action.begin
            case .abort: return Localized.Task.Action.abort
            case .finish: return Localized.Task.Action.finish
            case .remake: return Localized.Task.Action.remake
            }
        }
        
        fileprivate init(_ kind: Kind) {
            self.kind = kind
        }
        
        fileprivate enum Kind {
            case begin, abort, finish, remake
        }
    }
}

extension Task.Status {
    private mutating func begin() {
        if self == .toDo { self = .doing }
    }
    
    private mutating func abort() {
        if self == .doing { self = .toDo }
    }
    
    private mutating func finish() {
        if self == .doing { self = .done }
    }
    
    private mutating func remake() {
        if self == .done { self = .toDo }
    }
}
