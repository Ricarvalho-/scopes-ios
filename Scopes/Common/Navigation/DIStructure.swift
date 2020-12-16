//
//  DIStructure.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import Foundation

protocol DITarget {
    var field: DIField<Any> { get }
}

extension DITarget {
    func safeDependency<D>() -> D? {
        field.dependency as? D
    }
}

protocol TypedDITarget: DITarget {
    associatedtype Dependency
}

extension TypedDITarget {
    var safeDependency: Dependency? {
        safeDependency()
    }
}

class DIField<D> {
    typealias DIListener = (D) -> Void
    
    private let didInject: DIListener?
    var dependency: D? = nil
    
    init(_ listener: DIListener? = nil) {
        didInject = listener
    }
    
    func inject(_ dependency: D) {
        self.dependency = dependency
        didInject?(dependency)
    }
}

struct DIContainer<D> {
    private let dependency: D?
    
    init(_ dependency: D? = nil) {
        self.dependency = dependency
    }
    
    func performInjection(into field: DIField<D>) {
        if let dependency = dependency {
            field.inject(dependency)
        }
    }
}
