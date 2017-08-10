//
//  RxScrollableGraphViewAdapter.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ScrollableGraphView

// objc monkey business
class _RxScrollableGraphViewReactiveArrayDataSource
    : NSObject
    , ScrollableGraphViewDataSource
{
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return 0
    }
}

class RxScrollableGraphViewReactiveArrayDataSourceSequenceWrapper<S: Sequence>
    : RxScrollableGraphViewReactiveArrayDataSource<S.Iterator.Element>
    , RxScrollableGraphViewDataSourceType
{
    typealias Element = S
    
    func scrollableGraphView(_ scrollableGraphView: ScrollableGraphView, observedEvent: Event<S>)
    {
        UIBindingObserver(UIElement: self) { scrollableGraphViewDataSource, sectionModels in
            let sections = Array(sectionModels)
            
            scrollableGraphViewDataSource.scrollableGraphView(scrollableGraphView, observedElements: sections as! [GraphSeries])
            }
            .on(observedEvent)
    }
}

class RxScrollableGraphViewReactiveArrayDataSource<Element>
    : _RxScrollableGraphViewReactiveArrayDataSource
{
    fileprivate var itemModels: [GraphSeries]? = nil
    
    // data source
    
    override func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if let series = self.itemModels?.filter({ series in series.name == plot.identifier }).first,
            series.values.count > pointIndex,
            pointIndex >= 0
        {
            return series.values[pointIndex].value
        }
        
        return 0
    }
    
    override func label(atIndex pointIndex: Int) -> String {
        if let series = self.itemModels?.first,
            series.values.count > pointIndex,
            pointIndex >= 0
        {
            return series.values[pointIndex].label
        }
        
        return "N/A"
    }
    
    override func numberOfPoints() -> Int {
        guard let itemModels = self.itemModels else {
            return 0
        }
        
        return itemModels.reduce(0) { acc, series in
            return acc > series.values.count ? acc : series.values.count
        }
    }
    
    // reactive
    
    func scrollableGraphView(_ scrollableGraphView: ScrollableGraphView, observedElements: [GraphSeries]) {
        self.itemModels = observedElements
        
        scrollableGraphView.reload()
    }
}
