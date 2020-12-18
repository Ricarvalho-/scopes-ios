//
//  TasksViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

protocol TaskVO {
    var title: String { get set }
    var status: Localizable & CommandProvider { get set }
}

class TasksViewController: UITableViewController, TypedDITarget {
    typealias Dependency = AnyRepository<TaskVO>
    
    let field = DIField<Any>()
}
