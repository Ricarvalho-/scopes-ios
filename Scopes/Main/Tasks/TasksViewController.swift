//
//  TasksViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

class TasksViewController: UITableViewController, TypedDITarget {
    typealias Dependency = FutureRepository<Task>
    
    let field = DIField<Any>()
    
    private var contentManager: ContentScreenManager<Task>? = nil
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentManager?.refreshContent()
    }
    
    @IBAction func refreshContent() {
        contentManager?.refreshContent()
    }
    
    @IBAction func didTapAdd() {
        contentManager?.askItemTitle { [weak self] title in
            self?.contentManager?.create(new: Task(title: title,
                                                   status: .toDo))
        }
    }
}

extension TasksViewController: ContentScreenManagerDelegate {
    func update(cell: UITableViewCell, for item: Task) {
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.status.localized
    }
    
    func didSelect(_ item: IdentifiableItem<Task>) {
        var task = item.item
        let actionChooser = UIAlertController(
            title: Localized.Task.Title.changeStatus.localized,
            message: String(
                format: Localized.Task.Message.currentStatus.localized,
                task.title,
                task.status.localized
            ),
            preferredStyle: .actionSheet
        )
        
        task.status.availableCommands.map { command in
            UIAlertAction(
                title: command.title.localized,
                style: .default,
                handler: { [weak self] _ in
                    task.status.perform(command)
                    self?.contentManager?.update(oldItem: item, with: task)
                }
            )
        }.forEach {
            actionChooser.addAction($0)
        }
        
        actionChooser.addAction(UIAlertAction(
            title: Localized.General.Action.cancel.localized,
            style: .cancel
        ))
        
        present(actionChooser, animated: true)
    }
    
    func startEditing(
        _ item: IdentifiableItem<Task>,
        onCancel: @escaping () -> Void,
        completion: @escaping (EmptyResult) -> Void
    ) {
        contentManager?.askItemTitle(
            currentTitle: item.item.title,
            onCancel: onCancel
        ) { [weak self] title in
            self?.contentManager?.update(
                oldItem: item,
                with: Task(title: title, status: item.item.status),
                completion: completion
            )
        }
    }
}
