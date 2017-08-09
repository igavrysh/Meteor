//
//  Scene.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation
import UIKit

enum Scene {
    case bars(BarsViewModel)
    //case editLocation(EditLocationViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .bars(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Bars") as! UINavigationController
            var vc = nc.viewControllers.first as! BarsViewController
            vc.bindViewModel(to: viewModel)
            
            return nc
          
        /*
        case .editLocation(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditLocation") as! UINavigationController
            var vc = nc.viewControllers.first as! EditLocationViewController
            vc.bindViewModel(to: viewModel)
            
            return nc
        */
        }
    }
}
