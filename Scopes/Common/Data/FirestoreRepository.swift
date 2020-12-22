//
//  FirestoreRepository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 17/12/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirestoreRepository: Repository where Element: Codable {
    var database: Firestore { get }
    var collection: CollectionReference { get }
}

extension FirestoreRepository {
    func create(
        new element: Element,
        completion: @escaping (ValueResult<IdentifiableElement>) -> Void
    ) {
        do {
            var newRef: DocumentReference?
            newRef = try collection.addDocument(
                from: element,
                completion: handle(completion) {
                    guard let newRef = newRef else { return nil }
                    return IdentifiableItem(id: newRef.documentID,
                                            path: newRef.path,
                                            item: element)
                }
            )
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func obtain(
        first elements: Int,
        after element: IdentifiableElement?,
        completion: @escaping (ValueResult<([IdentifiableElement], Bool)>) -> Void
    ) {
        let query = collection.limit(to: elements)
        guard let element = element else {
            perform(query, elements, completion)
            return
        }
        
        database.document(element.path).getDocument(
            source: .cache,
            completion: handle(completion) { snapshot in
                perform(query.start(afterDocument: snapshot), elements, completion)
            }
        )
    }
    
    func update(
        _ element: IdentifiableElement,
        completion: @escaping (EmptyResult) -> Void
    ) {
        do {
            try database.document(element.path).setData(
                from: element.item,
                completion: handle(completion)
            )
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(
        _ element: IdentifiableElement,
        completion: @escaping (EmptyResult) -> Void
    ) {
        database.document(element.path).delete(completion: handle(completion))
    }
}

extension FirestoreRepository {
    fileprivate func perform(
        _ query: Query,
        _ amount: Int,
        _ completion: @escaping (ValueResult<([IdentifiableElement], Bool)>) -> Void
    ) {
        query.getDocuments(
            completion: handle(completion) { querySnapshot in
                let items = querySnapshot.documents.compactMap(toIdentifiableElement(_:))
                let canHaveMore = querySnapshot.count == amount
                completion(.success((items, canHaveMore)))
            }
        )
    }
    
    fileprivate func toIdentifiableElement(_ snapshot: QueryDocumentSnapshot) -> IdentifiableElement? {
        do {
            if let data = try snapshot.data(as: Element.self) {
                return IdentifiableItem(id: snapshot.documentID,
                                        path: snapshot.reference.path,
                                        item: data)
            }
        } catch let error {
            Crashlytics.crashlytics().record(error: error)
        }
        return nil
    }
}

extension FirestoreRepository {
    fileprivate func handle(
        _ completion: @escaping (EmptyResult) -> Void
    ) -> (Error?) -> Void {
        return { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    fileprivate func handle<T>(
        _ completion: @escaping (ValueResult<T>) -> Void,
        _ successValue: @escaping () -> T?
    ) -> (Error?) -> Void {
        return { error in
            if let error = error {
                completion(.failure(error))
            } else if let value = successValue() {
                completion(.success(value))
            }
        }
    }
    
    fileprivate func handle<T, R>(
        _ completion: @escaping (ValueResult<R>) -> Void,
        _ success: @escaping (T) -> Void
    ) -> (T?, Error?) -> Void {
        return { value, error in
            if let error = error {
                completion(.failure(error))
            } else if let value = value {
                success(value)
            }
        }
    }
}
