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
    func navigate(_ structuredSegue: StructuredSafeDISegue) {
        navigate(with: structuredSegue.segue)
    }
    
    func navigate(with safeSegue: SafeDISegue) {
        performSegue(withIdentifier: safeSegue.identifier, sender: safeSegue)
    }
    
    fileprivate func possibleTargets(for destination: UIViewController) -> [DITarget] {
        var availableViewControllers = [destination]
        
        if let navigation = destination as? UINavigationController {
            availableViewControllers.append(contentsOf: navigation.viewControllers)
        }
        
        if let tapBarController = destination as? UITabBarController,
           let viewControllers = tapBarController.viewControllers {
            availableViewControllers.append(contentsOf: viewControllers)
        }
        
        return availableViewControllers.compactMap({ $0 as? DITarget })
    }
}

extension UIViewController: DISegueCoordinator {
    @objc dynamic private func swizzledPrepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let safeSegue = sender as? SafeDISegue {
            possibleTargets(for: segue.destination).forEach() { target in
                safeSegue.diContainer?.performInjection(into: target.field)
            }
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
