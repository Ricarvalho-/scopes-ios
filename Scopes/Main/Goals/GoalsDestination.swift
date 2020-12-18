//
//  GoalsDestination.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 16/12/20.
//

import Foundation

extension StructuredSafeDISegue.Origin {
    static func goals(to target: GoalsDestination) -> Self {
        Self(target.segue)
    }
    
    struct GoalsDestination: CompositeSafeDISegue {
        let segue: SafeDISegue
    }
}

extension StructuredSafeDISegue.Origin.GoalsDestination {
    static func tasks<T: TaskVO>(_ tasksRepository: AnyRepository<T>) -> Self {
        Self(SafeDISegue("goalsToTasks", tasksRepository))
    }
}
