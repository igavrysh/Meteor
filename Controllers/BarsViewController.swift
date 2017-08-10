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

class BarsViewController: UIViewController, BindableType {
    
    let disposeBag = DisposeBag()
    
    var viewModel: BarsViewModel!
    
    var barsView: BarsView {
        return self.view as! BarsView
    }
    
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
            .do(onNext: { seriesArray in
                _ = seriesArray.map { [weak self] series in
                    self?.barsView.addDarkLinePlot(identifier: series.name)
                }
            })
            .bind(to: self.barsView.graphView.rx.items)
            .addDisposableTo(self.disposeBag)
    }
    
    private func configureDataSource() {
        self.dataSource.titleForHeaderInSection = { dataSource, index in
            self.dataSource.sectionModels[index].model
        }
        
        self.dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, bar in
            let cell = self?.barsView.tableView.dequeueReusableCell(withIdentifier: "BarTableViewCell", for: indexPath) as! BarTableViewCell
            
            if self != nil {
                cell.configure(with: bar)
            }
            
            return cell
        }
        
        self.dataSource.canEditRowAtIndexPath = { _ in true }
    }
}
