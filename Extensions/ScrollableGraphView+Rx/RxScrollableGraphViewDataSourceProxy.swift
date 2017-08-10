//
//  RxScrollableGraphViewDataSourceProxy.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ScrollableGraphView

let scrollableGraphViewDataSourceNotSet = ScrollableGraphViewDataSourceNotSet()

final class ScrollableGraphViewDataSourceNotSet
    : NSObject
    , ScrollableGraphViewDataSource  {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "NA"
    }
    
    func numberOfPoints() -> Int {
        return 0
    }
}

public class RxScrollableGraphViewDataSourceProxy
    : DelegateProxy
    , ScrollableGraphViewDataSource
    , DelegateProxyType
{
    /// Typed parent object.
    
    public weak private(set) var scrollableGraphView: ScrollableGraphView?
    
    fileprivate var _requiredMethodsDataSource: ScrollableGraphViewDataSource? = scrollableGraphViewDataSourceNotSet
    
    /// Initializes `RxScrollableGraphViewDataSourceProxy`
    ///
    /// - parameter parentObject: Parent object for delegate proxy.
    public required init(parentObject: AnyObject) {
        self.scrollableGraphView = castOrFatalError(parentObject)
        super.init(parentObject: parentObject)
    }
    
    // MARK: ScrollableGraphViewDataSource
    
    /// Required delegate method implementation.
    public func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return (_requiredMethodsDataSource ?? scrollableGraphViewDataSourceNotSet).value(forPlot: plot, atIndex: pointIndex)
    }
    
    /// Required delegate method implementation.
    public func label(atIndex pointIndex: Int) -> String{
        return (_requiredMethodsDataSource ?? scrollableGraphViewDataSourceNotSet).label(atIndex: pointIndex)
    }
    
    /// Required delegate method implementation.
    public func numberOfPoints() -> Int {
        return (_requiredMethodsDataSource ?? scrollableGraphViewDataSourceNotSet).numberOfPoints()
    }
    
    // MARK: proxy
    
    /// For more information take a look at `DelegateProxyType`.
    public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
        let scrollableGraphView: ScrollableGraphView = castOrFatalError(object)
        return scrollableGraphView.createRxDataSourceProxy()
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public override class func delegateAssociatedObjectTag() -> UnsafeRawPointer {
        return dataSourceAssociatedTag
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let scrollableGraphView: ScrollableGraphView = castOrFatalError(object)
        scrollableGraphView.dataSource = castOptionalOrFatalError(delegate)
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let scrollableGraphView: ScrollableGraphView = castOrFatalError(object)
        
        return scrollableGraphView.dataSource as AnyObject?
    }
    
    /// For more information take a look at `DelegateProxyType`.
    
    public override func setForwardToDelegate(_ forwardToDelegate: AnyObject?, retainDelegate: Bool) {
        let requiredMethodsDataSource: ScrollableGraphViewDataSource? = castOptionalOrFatalError(forwardToDelegate)
        _requiredMethodsDataSource = requiredMethodsDataSource ?? scrollableGraphViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}


let dataSourceNotSet = "DataSource not set"

/// Swift does not implement abstract methods. This method is used as a runtime check to ensure that methods which intended to be abstract (i.e., they should be implemented in subclasses) are not called directly on the superclass.
func rxAbstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    rxFatalError(message, file: file, line: line)
}

func rxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never  {
    // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
    fatalError(lastMessage(), file: file, line: line)
}


func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from \(value) to \(T.self)")
    }
    
    return result
}

// workaround for Swift compiler bug, cheers compiler team :)
func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

var dataSourceAssociatedTag: UnsafeRawPointer = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))

