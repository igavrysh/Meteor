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

typealias SeriesCollection = [String: [Double]]

class RxScrollableGraphViewDictionaryDataSource
    : NSObject
    , ScrollableGraphViewDataSource
{
    fileprivate var items: SeriesCollection = [:]
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if let series = self.items[plot.identifier],
            pointIndex < series.count
        {
            return series[pointIndex]
        }
    
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "XO"
    }
    
    func numberOfPoints() -> Int {
        return self.items.reduce(0) { acc, tuple in
            return acc > tuple.value.count ? acc : tuple.value.count
        }
    }
}

class RxScrollableViewSequenceDataSource<S: Sequence>
    : RxScrollableGraphViewDictionaryDataSource
    , RxScrollableGraphViewDataSourceType
{
    func scrollableGraphView(_ scrollableGraphView: ScrollableGraphView, observedEvent: Event<S>) {
        UIBindingObserver(UIElement: self) { dataSource, items in
            dataSource.items = items
            scrollableGraphView.reload()
        }
        .on(observedEvent.map { _ in SeriesCollection() })
    }
    
}
