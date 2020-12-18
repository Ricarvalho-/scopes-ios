//
//  ScopesViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

protocol ScopeVO {
    var title: String { get set }
}

class ScopesViewController: UITableViewController, TypedDITarget {
    typealias Dependency = AnyRepository<ScopeVO>
    
    let field = DIField<Any>()
}
