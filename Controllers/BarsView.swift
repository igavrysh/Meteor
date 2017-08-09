//
//  BarsView.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import ScrollableGraphView
import RxSwift
import RxCocoa
import RxDataSources

class BarsView: UIView {
    @IBOutlet var tableView: UITableView!
    var graphView: ScrollableGraphView!
    
    private var graphConstraints = [NSLayoutConstraint]()
    @IBOutlet private var graphPlaceholder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSubviews()
    }
    
    // MARK: - Public
    
    public func addDarkLinePlot(identifier: String) {
        let linePlot = LinePlot(identifier: identifier) // Identifier should be unique for each plot.
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.colorFromHex("#777777")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.colorFromHex("#555555")
        linePlot.fillGradientEndColor = UIColor.colorFromHex("#444444")
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        self.graphView.addPlot(plot: linePlot)
    }
    
    public func addDotPlot(identifier: String) {
        let dotPlot = DotPlot(identifier: identifier) // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        self.graphView.addPlot(plot: dotPlot)
    }
    
    // MARK: - Private
    private func initSubviews() {
        self.graphView = starWarsGraphView(frame: self.graphPlaceholder.bounds)
        self.addDarkLinePlot(identifier: "darkLine")
        self.addDotPlot(identifier: "darkLineDot")
        
        /*self.graphView.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleWidth,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleHeight,
            .flexibleBottomMargin
        ];*/
        
        self.graphPlaceholder.addSubview(self.graphView)
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        setupConstraints()
    }
    
    private func starWarsGraphView(frame:CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame)
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.positionType = .relative
        // Reference lines will be shown at these values on the y-axis.
        referenceLines.includeMinMax = true
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        graphView.backgroundFillColor = UIColor.colorFromHex("#333333")
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.rangeMax = 211
        
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        return graphView
    }
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        self.graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.graphPlaceholder, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.graphPlaceholder, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.graphPlaceholder, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.graphPlaceholder, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        self.graphConstraints.append(topConstraint)
        self.graphConstraints.append(bottomConstraint)
        self.graphConstraints.append(leftConstraint)
        self.graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.graphPlaceholder.addConstraints(graphConstraints)
    }
}
