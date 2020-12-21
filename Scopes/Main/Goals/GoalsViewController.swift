//
//  GoalsViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

class GoalsViewController: UITableViewController, TypedDITarget {
    typealias Dependency = FutureRepository<Goal>
    
    let field = DIField<Any>()
}
