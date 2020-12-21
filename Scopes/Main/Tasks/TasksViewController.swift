//
//  TasksViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

class TasksViewController: UITableViewController, TypedDITarget {
    typealias Dependency = AnyRepository<Task>
    
    let field = DIField<Any>()
}
