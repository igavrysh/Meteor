//
//  BarsViewController.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ScrollableGraphView

class BarsViewController: UIViewController, BindableType, ScrollableGraphViewDataSource {
    
    let disposeBag = DisposeBag()
    
    var viewModel: BarsViewModel!
    
    var barsView: BarsView {
        return self.view as! BarsView
    }
    
    private var seriesTuple: SeriesTuple = ([], [:])
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<BarSection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        configureDataSource()
    }
    
    func bindViewModel() {
        self.viewModel.bars
            .bind(to: self.barsView.tableView.rx.items(dataSource: self.dataSource))
            .addDisposableTo(self.disposeBag)
        
        self.viewModel.series
            .do(onNext: { (seriesTuple: SeriesTuple) in
                for (name, _) in seriesTuple.series {
                    self.barsView.addDarkLinePlot(identifier: name)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (seriesTuple: SeriesTuple) in
                self?.seriesTuple = seriesTuple
                
                self?.barsView.graphView.dataSource = self
                
                self?.barsView.graphView.reload()
            })
            .addDisposableTo(self.disposeBag)
    }
    
    private func configureDataSource() {
        self.dataSource.titleForHeaderInSection = { dataSource, index in
            self.dataSource.sectionModels[index].model
        }
        
        self.dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, bar in
            let cell = self?.barsView.tableView.dequeueReusableCell(withIdentifier: "BarTableViewCell", for: indexPath) as! BarTableViewCell
            
            if let strongSelf = self {
                cell.configure(with: bar)
            }
            
            return cell
        }
        
        self.dataSource.canEditRowAtIndexPath = { _ in true }
    }
    
    // MARK: - ScrollableGraphViewDataSource
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        guard let points = self.seriesTuple.series[plot.identifier],
            points.count > pointIndex
        else {
            return 0
        }
        
        return points[pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return self.seriesTuple.labels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return self.seriesTuple.series.reduce(0) { acc, tuple in
            return acc > tuple.value.count ? acc : tuple.value.count
        }
    }
}
