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
    
    private var contentManager: ContentScreenManager<Scope>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let repository = safeDependency {
            contentManager = ContentScreenManager(
                repository: repository,
                tableViewController: self,
                delegate: self
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentManager?.refreshContent()
    }
    
    @IBAction func refreshContent() {
        contentManager?.refreshContent()
    }
}

extension ScopesViewController: ContentScreenManagerDelegate {
    func update(cell: UITableViewCell, for item: Scope) {
        cell.textLabel?.text = item.title
    }
    
    func didSelect(_ item: IdentifiableItem<Scope>) {
        let goalsRepository = FirestoreGoalsRepository(parent: item)
        navigate(.from(.scopes(to: .goals(with: AnyRepository(goalsRepository)))))
    }
}
