//
//  ContentScreenManager.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 21/12/20.
//

import UIKit

class ContentScreenManager<T: Hashable>: NSObject, UITableViewDelegate {
    var delegate: AnyContentScreenManagerDelegate<T>? = nil
    
    private weak var refreshControl: UIRefreshControl?
    private let repository: FutureRepository<T>
    private let dataSource: UITableViewDiffableDataSource<Section, Item>
    
    private var canFetchMoreItems = false
    private var lastItem: IdentifiableItem<T>? {
        switch dataSource.snapshot().itemIdentifiers(inSection: .item).last {
        case .item(let item): return item
        default: return nil
        }
    }
    
    private enum Section: Int {
        case item, error
    }
    
    private enum Item: Hashable {
        case item(IdentifiableItem<T>), error(String)
        
        var cellId: String {
            switch self {
            case .item(_): return "itemCell"
            case .error(_): return "errorCell"
            }
        }
    }
    
    convenience init<D: ContentScreenManagerDelegate>(
        repository: FutureRepository<T>,
        tableViewController: UITableViewController,
        delegate: D? = nil
    ) where D.Item == T {
        self.init(
            repository: repository,
            tableView: tableViewController.tableView,
            refreshControl: tableViewController.refreshControl,
            delegate: delegate
        )
    }
    
    required init<D: ContentScreenManagerDelegate>(
        repository: FutureRepository<T>,
        tableView: UITableView,
        refreshControl: UIRefreshControl? = nil,
        delegate: D? = nil
    ) where D.Item == T {
        self.refreshControl = refreshControl
        self.repository = repository
        if let delegate = delegate {
            self.delegate = AnyContentScreenManagerDelegate(delegate)
        }
        
        dataSource = SwipeEnabledUITableViewDiffableDataSource<Section, Item>(
            tableView: tableView
        ) { [weak delegate] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: item.cellId,
                for: indexPath
            )
            switch item {
            case .item(let item): delegate?.update(cell: cell, for: item.item)
            case .error(_): break
            }
            return cell
        }
        
        super.init()
        tableView.delegate = self
        refreshContent()
    }
    
    func refreshContent() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.item, .error])
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.fetchItems()
        }
    }
    
    private func fetchItems() {
        repository.obtain(
            first: 10,
            after: lastItem
        ).onSuccess() { [weak self] (items, canLoadMore) in
            self?.update(content: items, canLoadMore)
        }.onFailure() { [weak self] error in
            self?.update(showing: error)
        }
    }
    
    private func update(
        content items: [IdentifiableItem<T>],
        _ canLoadMore: Bool
    ) {
        refreshControl?.endRefreshing()
        canFetchMoreItems = canLoadMore
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .error))
        snapshot.appendItems(items.map(Item.item), toSection: .item)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func update(showing error: Error) {
        refreshControl?.endRefreshing()
        canFetchMoreItems = false
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([.error(error.localizedDescription)],
                             toSection: .error)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let snapshot = dataSource.snapshot()
        guard canFetchMoreItems,
              indexPath.section == snapshot.indexOfSection(.item)
        else { return }
        
        let itemAmount = snapshot.numberOfItems(inSection: .item)
        let remainingItems = itemAmount - indexPath.row
        if remainingItems <= 2 {
            fetchItems()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataSource.itemIdentifier(for: indexPath) {
        case .item(let item): delegate?.didSelect(item)
        case .error(_): fetchItems()
        case .none: break
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        switch dataSource.itemIdentifier(for: indexPath) {
        case .error(let message):
            let alert = UIAlertController(
                title: Localized.General.Title.error.localized,
                message: message,
                preferredStyle: .alert
            )
            
            [UIAlertAction(
                title: Localized.General.Action.cancel.localized,
                style: .cancel),
             UIAlertAction(
                title: Localized.General.Action.retry.localized,
                style: .default,
                handler: { [weak self] _ in self?.fetchItems() })
            ].forEach() {
                alert.addAction($0)
            }
            
            delegate?.show(alert)
        default: break
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        .none
    }
}

protocol Alertable: AnyObject {
    func show(_ alert: UIAlertController)
}

extension UIViewController: Alertable {
    func show(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}

protocol ContentScreenManagerDelegate: Alertable {
    associatedtype Item: Hashable
    
    func update(cell: UITableViewCell, for item: Item)
    func didSelect(_ item: IdentifiableItem<Item>)
}

class AnyContentScreenManagerDelegate<T: Hashable>: ContentScreenManagerDelegate {
    private let update: (UITableViewCell, T) -> Void
    private let didSelect: (IdentifiableItem<T>) -> Void
    private let show: (UIAlertController) -> Void
    
    init<D: ContentScreenManagerDelegate>(_ delegate: D) where D.Item == T {
        update = { [weak delegate] in
            delegate?.update(cell: $0, for: $1)
        }
        didSelect = { [weak delegate] in
            delegate?.didSelect($0)
        }
        show = { [weak delegate] in
            delegate?.show($0)
        }
    }
    
    func update(cell: UITableViewCell, for item: T) {
        update(cell, item)
    }
    
    func didSelect(_ item: IdentifiableItem<T>) {
        didSelect(item)
    }
    
    func show(_ alert: UIAlertController) {
        show(alert)
    }
}
