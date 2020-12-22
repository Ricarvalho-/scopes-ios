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
    
    private var contentManager: ContentScreenManager<Goal>? = nil
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
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

extension GoalsViewController: ContentScreenManagerDelegate {
    func update(cell: UITableViewCell, for item: Goal) {
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = dateFormatter.string(from: item.dueDate)
    }
    
    func didSelect(_ item: IdentifiableItem<Goal>) {
        let tasksRepository = FirestoreTasksRepository(parent: item)
        navigate(.from(.goals(to: .tasks(AnyRepository(tasksRepository)))))
    }
}
