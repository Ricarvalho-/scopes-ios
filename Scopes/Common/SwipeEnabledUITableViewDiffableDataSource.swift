//
//  SwipeEnabledUITableViewDiffableDataSource.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 21/12/20.
//

import UIKit

class SwipeEnabledUITableViewDiffableDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
