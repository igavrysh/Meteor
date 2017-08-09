//
//  BarsViewModel.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias DataPoint = (date: String, tmin: Double?, tmax: Double?)
typealias SeriesTuple = (labels: [String], series: SeriesCollection)

typealias BarSection = AnimatableSectionModel<String, Bar>

struct BarsViewModel {
    let sceneCoordinator: SceneCoordinator
    let barService: BarServiceType
    
    init(barService: BarServiceType, coordinator: SceneCoordinator) {
        self.barService = barService
        self.sceneCoordinator = coordinator
    }
    
    var history: Observable<[DataPoint]> {
        return self.barService.bars().map { bars in
            bars.map { bar in
                DataPoint(
                    date: String.monthShortcut(no: bar.month) + " " + String(bar.year % 100),
                    tmin: bar.minTemperature,
                    tmax: bar.maxTemperature
                )
            }
        }
    }
    
    var bars: Observable<[BarSection]> {
        return self.barService.bars().map { bars in
            return [BarSection(model: bars.first?.city ?? "Bars", items: bars)]
        }
    }
    
    var series: Observable<SeriesTuple> {
        return self.barService.bars()
            .map { bars in
                return bars.filter { $0.maxTemperature != nil && $0.minTemperature != nil }
            }
            .map { bars in
                return SeriesTuple(
                    labels: bars.map { String.monthShortcut(no: $0.month) + " " + String($0.year) },
                    series: [
                        "tmax": bars.map { $0.maxTemperature ?? 0 },
                        "tmin": bars.map { $0.minTemperature ?? 0 }
                    ]
                )
        }
    }
}
