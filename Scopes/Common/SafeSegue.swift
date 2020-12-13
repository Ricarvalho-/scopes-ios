//
//  SafeSegue.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import Foundation

struct SafeSegue {
    let destination: DIDestination
    
    init(_ destination: DIDestination) {
        self.destination = destination
    }
}

extension SafeSegue {
    static func from(_ origin: SafeSegue.Origin) -> Self {
        SafeSegue(origin.segue.destination)
    }
    
    struct Origin: CompositeSafeSegue {
        let segue: SafeSegue
    }
}

protocol CompositeSafeSegue: Any {
    var segue: SafeSegue { get }
    init(segue: SafeSegue)
}

extension CompositeSafeSegue {
    init(_ segue: SafeSegue) {
        self.init(segue: segue)
    }
}
