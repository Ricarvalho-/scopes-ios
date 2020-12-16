//
//  StartDestination.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import Foundation

extension StructuredSafeDISegue.Origin {
    static func start(to target: StartDestination) -> Self {
        Self(target.segue)
    }
    
    struct StartDestination: CompositeSafeDISegue {
        let segue: SafeDISegue
    }
}

extension StructuredSafeDISegue.Origin.StartDestination {
    static var login: Self {
        Self(SafeDISegue("startToLogin"))
    }

    static func main() -> Self {
        Self(SafeDISegue("startToMain"))
    }
}
