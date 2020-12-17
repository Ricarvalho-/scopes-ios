//
//  Repository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 16/12/20.
//

import Foundation

typealias ValueResult<T> = Result<T, Error>
typealias EmptyResult = Result<Void, Error>

protocol Repository {
    associatedtype Element
    
    func create(new element: Element,
                completion: (ValueResult<Element>) -> Void)
    
    func obtain(first elements: Int,
                after element: Element?,
                completion: (ValueResult<[Element]>) -> Void)
    
    func update(_ element: Element, completion: (EmptyResult) -> Void)
    
    func delete(_ element: Element, completion: (EmptyResult) -> Void)
}

struct AnyRepository<E>: Repository {
    private let create: (E, (ValueResult<E>) -> Void) -> Void
    private let obtain: (Int, E?, (ValueResult<[E]>) -> Void) -> Void
    private let update: (E, (EmptyResult) -> Void) -> Void
    private let delete: (E, (EmptyResult) -> Void) -> Void
    
    init<R: Repository>(_ repository: R) where R.Element == E {
        create = repository.create
        obtain = repository.obtain
        update = repository.update
        delete = repository.delete
    }
    
    func create(new element: E, completion: (ValueResult<E>) -> Void) {
        create(element, completion)
    }
    
    func obtain(
        first elements: Int = 10,
        after element: E? = nil,
        completion: (ValueResult<[E]>) -> Void
    ) {
        obtain(elements, element, completion)
    }
    
    func update(_ element: E, completion: (EmptyResult) -> Void) {
        update(element, completion)
    }
    
    func delete(_ element: E, completion: (EmptyResult) -> Void) {
        delete(element, completion)
    }
}
