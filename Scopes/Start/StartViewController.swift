//
//  StartViewController.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

class StartViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigate(.from(.start(to: .main(AnyRepository(FirestoreScopesRepository())))))
    }
}
