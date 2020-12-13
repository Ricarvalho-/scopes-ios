//
//  DISegueCoordinator.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 13/12/20.
//

import UIKit

protocol DISegueCoordinator {
    func performSegue(withIdentifier identifier: String, sender: Any?)
}

extension DISegueCoordinator {
    func navigate(_ safeSegue: SafeSegue) {
        navigate(to: safeSegue.destination)
    }
    
    func navigate(to destination: DIDestination) {
        performSegue(withIdentifier: destination.identifier, sender: destination)
    }
}

extension UIViewController: DISegueCoordinator {
    @objc dynamic private func swizzledPrepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = sender as? DIDestination,
           let target = segue.destination as? DITarget,
           let targetField = target.field {
            destination.diContainer?.performInjection(into: targetField)
        }
        swizzledPrepare(for: segue, sender: sender)
    }
    
    class func swizzlePrepareForSegueWithDI() {
        guard
            let originalMethod = class_getInstanceMethod(
                UIViewController.self,
                #selector(UIViewController.prepare(for:sender:))
            ),
            let swizzledMethod = class_getInstanceMethod(
                UIViewController.self,
                #selector(UIViewController.swizzledPrepare(for:sender:))
            )
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
