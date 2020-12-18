//
//  ScopesDestination.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 16/12/20.
//

import Foundation

extension StructuredSafeDISegue.Origin {
    static func scopes(to target: ScopesDestination) -> Self {
        Self(target.segue)
    }
    
    struct ScopesDestination: CompositeSafeDISegue {
        let segue: SafeDISegue
    }
}

extension StructuredSafeDISegue.Origin.ScopesDestination {
    static func goals<T: GoalVO>(_ goalsRepository: AnyRepository<T>) -> Self {
        Self(SafeDISegue("scopesToGoals", goalsRepository))
    }
}
