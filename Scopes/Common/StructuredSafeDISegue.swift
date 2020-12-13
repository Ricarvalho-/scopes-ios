//
//  StructuredSafeDISegue.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import Foundation

struct StructuredSafeDISegue: CompositeSafeDISegue {
    let segue: SafeDISegue
}

extension StructuredSafeDISegue {
    static func from(_ origin: StructuredSafeDISegue.Origin) -> Self {
        Self(origin.segue)
    }
    
    struct Origin: CompositeSafeDISegue {
        let segue: SafeDISegue
    }
}

protocol CompositeSafeDISegue {
    var segue: SafeDISegue { get }
    init(segue: SafeDISegue)
}

extension CompositeSafeDISegue {
    init(_ segue: SafeDISegue) {
        self.init(segue: segue)
    }
}
