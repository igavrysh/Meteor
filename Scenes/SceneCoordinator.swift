//
//  SceneCoordinator.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        self.currentViewController = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            self.currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
            
        case .push:
            guard let navigationController = self.currentViewController.navigationController else {
                fatalError("Cannot push a view controller without current navigation controller")
            }
            
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bindTo(subject)
            
            navigationController.pushViewController(viewController, animated: true)
            self.currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
            
        case .modal:
            self.currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            
            self.currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        if let presenter = self.currentViewController.presentingViewController {
            self.currentViewController.dismiss(animated: true) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = self.currentViewController.navigationController {
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bindTo(subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("Cannot navigate back from \(self.currentViewController)")
            }
            
            self.currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: cannot navigate back from \(self.currentViewController)")
        }
        
        return subject.asObservable().take(1).ignoreElements()
        
    }
}
