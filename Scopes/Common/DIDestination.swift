//
//  DIDestination.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import Foundation

protocol IdentifiableSegue {
    var identifier: String { get }
}

class DIDestination: IdentifiableSegue {
    let identifier: String
    let diContainer: DIContainer<Any>?
    
    init(_ identifier: String, _ dependency: Any? = nil) {
        self.identifier = identifier
        if let dependency = dependency {
            diContainer = DIContainer(dependency)
        } else {
            diContainer = nil
        }
    }
}
