//
//  SceneCoordinatorType.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}
