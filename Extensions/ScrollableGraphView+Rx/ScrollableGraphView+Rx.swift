//
//  ScrollableGraphView+Rx.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ScrollableGraphView

extension ScrollableGraphView {
    
    /// Factory method that enables subclasses to implement their own `delegate`.
    ///
    /// - returns: Instance of delegate proxy that wraps `delegate`.
    /**
     public override func createRxDelegateProxy() -> RxScrollViewDelegateProxy {
     return RxTableViewDelegateProxy(parentObject: self)
     }
     */
    
    /**
     Factory method that enables subclasses to implement their own `rx.dataSource`.
     
     - returns: Instance of delegate proxy that wraps `dataSource`.
     */
    
    public func createRxDataSourceProxy() -> RxScrollableGraphViewDataSourceProxy {
        return RxScrollableGraphViewDataSourceProxy(parentObject: self)
    }
}

extension Reactive where Base: ScrollableGraphView  {
    
    /**
     Reactive wrapper for `dataSource`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var dataSource: DelegateProxy {
        return RxScrollableGraphViewDataSourceProxy.proxyForObject(base)
    }
    
    /**
     Binds sequences of elements to scrollable graph view plots.
     
     - parameter source: Observable sequence of items.
     - returns: Disposable object that can be used to unbind.
     
     Example:
     
        let items = Observable.just([
            "First Series" : [1.2, 1, 2, 3],
            "Second Series" : [777, 69.96],
            "Third Series" : [0.0]
        ])
     
        items.bind(to: pickerView.rx.items)
        .disposed(by: disposeBag)
     
     */

    public func items<S: Sequence, O: ObservableType>(_ source: O)
        -> Disposable
        where O.E == S
    {
        let adapter = RxScrollableViewSequenceDataSource<S>()
        return self.items(adapter: adapter)(source)
    }
    
    public func items<O: ObservableType, Adapter:RxScrollableGraphViewDataSourceType & ScrollableGraphViewDataSource & AnyObject>(adapter: Adapter)
        -> (_ source: O)
        -> Disposable where O.E == Adapter.Element
        
    {
        return { source in
            let dataSourceSubscription
                = source.subscribeProxyDataSource(
                    ofObject: self.base,
                    dataSource: adapter,
                    retainDataSource: true,
                    binding: { [weak scrollableGraphView = self.base] (_: RxScrollableGraphViewDataSourceProxy, event) in
                        guard let scrollableGraphView = scrollableGraphView else {
                            return
                        }
                        
                        adapter.scrollableGraphView(scrollableGraphView, observedEvent: event)
                    }
            )
            
            return Disposables.create([dataSourceSubscription])
        }
    }
}

extension ObservableType {
    func subscribeProxyDataSource<P: DelegateProxyType>(ofObject object: UIView, dataSource: AnyObject, retainDataSource: Bool, binding: @escaping (P, Event<E>) -> Void)
        -> Disposable {
            let proxy = P.proxyForObject(object)
            let unregisterDelegate = P.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            object.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingErrorToInterface(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(object.rx.deallocated)
                .subscribe { [weak object] (event: Event<E>) in
                    
                    if let object = object {
                        assert(proxy === P.currentDelegateFor(object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: P.currentDelegateFor(object)))")
                    }
                    
                    binding(proxy, event)
                    
                    switch event {
                    case .error(let error):
                        bindingErrorToInterface(error)
                        unregisterDelegate.dispose()
                    case .completed:
                        unregisterDelegate.dispose()
                    default:
                        break
                    }
            }
            
            return Disposables.create { [weak object] in
                subscription.dispose()
                object?.layoutIfNeeded()
                unregisterDelegate.dispose()
            }
    }
}

// MARK: Error binding policies

func bindingErrorToInterface(_ error: Swift.Error) {
    let error = "Binding error to UI: \(error)"
    #if DEBUG
        rxFatalError(error)
    #else
        print(error)
    #endif
}
