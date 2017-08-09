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
    @IBOutlet var airfrostLabel: UILabel!
    @IBOutlet var rainfallLabel: UILabel!
    @IBOutlet var sunshineDurationLabel: UILabel!
    
    func configure(with bar: Bar) {
        self.dateLabel.text = String.monthShortcut(no: bar.month) + " " + String(bar.year)
        
        self.minTempLabel.text = convertToString(value: bar.minTemperature, prefix: "MIN ", suffix: "℃")
        self.maxTempLabel.text = convertToString(value: bar.maxTemperature, prefix: "MAX ", suffix: "℃")
        self.airfrostLabel.text = convertToString(value: bar.airFrost, prefix: "AIRFROST ", suffix: "d")
        self.rainfallLabel.text = convertToString(value: bar.rainfall, prefix: "RAINFALL ", suffix: "mm")
        self.sunshineDurationLabel.text = convertToString(value: bar.sunshineDuration, prefix: "Sun.Dur. ", suffix: "h")
    }
    
    private func convertToString<T>(value: T?, prefix: String, suffix: String) -> String {
        var converted = ""
        if let value = value {
            converted = String(describing: value) + suffix
        } else {
            converted = "N/A"
        }
        
        return prefix + converted
    }
}
