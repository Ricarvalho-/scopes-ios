//
//  ScopesViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

class ScopesViewController: UITableViewController, TypedDITarget {
    typealias Dependency = FutureRepository<Scope>
    
    let field = DIField<Any>()
}
