//
//  Repository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 16/12/20.
//

import Foundation

protocol Repository {
    associatedtype Element
    
    func create(new element: Element, completion: (Element) -> Void)
    func obtain(first elements: Int, after element: Element?, completion: ([Element]) -> Void)
    func update(_ element: Element, completion: (Bool) -> Void)
    func delete(_ element: Element, completion: (Bool) -> Void)
}

struct AnyRepository<E>: Repository {
    private let create: (E, (E) -> Void) -> Void
    private let obtain: (Int, E?, ([E]) -> Void) -> Void
    private let update: (E, (Bool) -> Void) -> Void
    private let delete: (E, (Bool) -> Void) -> Void
    
    init<R: Repository>(_ repository: R) where R.Element == E {
        create = repository.create
        obtain = repository.obtain
        update = repository.update
        delete = repository.delete
    }
    
    func create(new element: E, completion: (E) -> Void) {
        create(element, completion)
    }
    
    func obtain(
        first elements: Int = 10,
        after element: Element? = nil,
        completion: ([Element]) -> Void
    ) {
        obtain(elements, element, completion)
    }
    
    func update(_ element: E, completion: (Bool) -> Void) {
        update(element, completion)
    }
    
    func delete(_ element: E, completion: (Bool) -> Void) {
        delete(element, completion)
    }
}
