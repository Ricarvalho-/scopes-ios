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
    private static let dateFormatter: DateFormatter = {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentManager?.refreshContent()
    }
    
    @IBAction func refreshContent() {
        contentManager?.refreshContent()
    }
    
    @IBAction func didTapAdd() {
        contentManager?.askItemDetails(
            additionalFields: [Field.dueDate]
        ) { [weak self] title, values in
            guard let dueDateText = values[.dueDate] as? String,
                  let dueDate = Self.dateFormatter.date(from: dueDateText)
            else { return }
            
            self?.contentManager?.create(new: Goal(title: title,
                                                   dueDate: dueDate))
        }
    }
    
    enum Field {
        case dueDate
    }
}

extension GoalsViewController: ContentScreenManagerDelegate {
    func update(cell: UITableViewCell, for item: Goal) {
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = Self.dateFormatter.string(from: item.dueDate)
    }
    
    func didSelect(_ item: IdentifiableItem<Goal>) {
        let tasksRepository = FirestoreTasksRepository(parent: item)
        navigate(.from(.goals(to: .tasks(with: AnyRepository(tasksRepository)))))
    }
}

extension GoalsViewController.Field: FieldProvider {
    var fieldSetup: FieldSetup {
        switch self {
        case .dueDate: return dueDateFieldSetup
        }
    }
    
    private func dueDateFieldSetup(
        _ field: UITextField,
        _ onUpdate: @escaping UIActionHandler
    ) {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        
        let updateFieldTextToPickerDate =
            { [weak field, weak datePicker] (action: UIAction) in
                guard let date = datePicker?.date else { return }
                field?.text = GoalsViewController.dateFormatter.string(from: date)
                field?.selectedTextRange = nil
                onUpdate(action)
            }
        
        datePicker.addAction(
            UIAction(handler: updateFieldTextToPickerDate),
            for: .valueChanged
        )
        field.addAction(
            UIAction(handler: updateFieldTextToPickerDate),
            for: .allEditingEvents
        )
        field.addAction(
            UIAction(handler: updateFieldTextToPickerDate),
            for: .allTouchEvents
        )
        
        field.inputView = datePicker
        field.placeholder = Localized.Goal.Field.dueDate.localized
    }
}
