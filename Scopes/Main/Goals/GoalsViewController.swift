//
//  GoalsViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

protocol GoalVO {
    var title: String { get set }
    var dueDate: Date { get set }
}

class GoalsViewController: UITableViewController, TypedDITarget {
    typealias Dependency = AnyRepository<GoalVO>
    
    let field = DIField<Any>()
}
