//
//  Future.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 20/12/20.
//

import Foundation

class Future<T> {
    fileprivate var onSuccess: [(T) -> Void] = []
    fileprivate var onFailure: [(Error) -> Void] = []
    
    @discardableResult func onSuccess(perform handler: @escaping (T) -> Void) -> Self {
        onSuccess.append(handler)
        return self
    }
    
    @discardableResult func onFailure(perform handler: @escaping (Error) -> Void) -> Self {
        onFailure.append(handler)
        return self
    }
}

class FutureResult<T>: Future<T> {
    lazy var resultHandler: (Result<T, Error>) -> Void = {
        switch $0 {
        case .success(let value): self.onSuccess.forEach { $0(value) }
        case .failure(let error): self.onFailure.forEach { $0(error) }
        }
    }
}
