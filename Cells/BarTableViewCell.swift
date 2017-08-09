//
//  BarTableViewCell.swift
//  Meteor
//
//  Created by Gavrysh on 8/9/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class BarTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    
    func configure(with bar: Bar) {
        self.dateLabel.text = String.monthShortcut(no: bar.month) + " " + String(bar.year)
        
        self.minTempLabel.text = "MIN: "
        if let temperature = bar.minTemperature {
            self.minTempLabel.text =  self.minTempLabel.text! + "\(temperature)℃"
        } else {
            self.minTempLabel.text =  self.minTempLabel.text! + " N/A"
        }
        
        self.maxTempLabel.text = "MAX: "
        if let temperature = bar.maxTemperature {
            self.maxTempLabel.text =  self.maxTempLabel.text! + "\(temperature)℃"
        } else {
            self.maxTempLabel.text =  self.maxTempLabel.text! + " N/A"
        }
    }
}
