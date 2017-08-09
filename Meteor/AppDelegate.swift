//
//  AppDelegate.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var disposeBag = DisposeBag()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let service = MetofficeService()
        let sceneCoordinator = SceneCoordinator(window: window!)
        let barsViewModel = BarsViewModel(barService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.bars(barsViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        
        return true
    }
}

