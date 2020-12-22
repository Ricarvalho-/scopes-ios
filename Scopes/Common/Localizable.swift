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
    enum General {
        enum Title {
            static var create = Localizer.make("general.title.create")
            static var edit = Localizer.make("general.title.edit")
            static var title = Localizer.make("general.title.title")
            static var error = Localizer.make("general.title.error")
            static var delete = Localizer.make("general.title.delete")
        }
        
        enum Message {
            static var undoableAction = Localizer.make("general.message.undoableaction")
        }
        
        enum Field {
            static var title = Localizer.make("general.field.title")
        }
        
        enum Action {
            static var cancel = Localizer.make("general.action.cancel")
            static var ok = Localizer.make("general.action.ok")
            static var retry = Localizer.make("general.action.retry")
            static var edit = Localizer.make("general.action.edit")
            static var delete = Localizer.make("general.action.delete")
        }
    }
    
    enum Goal {
        enum Field {
            static var dueDate = Localizer.make("goal.field.duedate")
        }
    }
    
    enum Task {
        enum Title {
            static var changeStatus = Localizer.make("task.title.changestatus")
        }
        
        enum Message {
            static var currentStatus = Localizer.make("task.message.currentstatus")
        }
        
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
