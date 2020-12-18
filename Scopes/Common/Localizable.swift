//
//  Localizable.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 18/12/20.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

private struct Localizer: Localizable {
    private let key: String
    private let comment: String
    var localized: String {
        NSLocalizedString(key, comment: comment)
    }
    
    static func make(_ key: String, comment: String = "") -> Localizable {
        Self(key: key, comment: comment)
    }
}

enum Localized {
    enum Task {
        enum Status {
            static var toDo = Localizer.make("task.status.todo")
            static var doing = Localizer.make("task.status.doing")
            static var done = Localizer.make("task.status.done")
        }
        
        enum Action {
            static var begin = Localizer.make("task.action.begin")
            static var abort = Localizer.make("task.action.abort")
            static var finish = Localizer.make("task.action.finish")
            static var remake = Localizer.make("task.action.remake")
        }
    }
}
