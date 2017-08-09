//
//  RxTableViewDataSourceType.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import ScrollableGraphView
    
/// Marks data source as `ScrollableGraphView` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxScrollableGraphViewDataSourceType {
    /// Type of elements that can be bound to table view.
    associatedtype Element
        
    /// New observable sequence event observed.
    ///
    /// - parameter tableView: Bound table view.
    /// - parameter observedEvent: Event
    func scrollableGraphView(_ scrollableGraphView: ScrollableGraphView, observedEvent: Event<Element>)
}

