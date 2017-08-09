//
//  Bar.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation
import RxDataSources

struct Bar  {
    // city name
    var city: String
    
    // within timeframe
    var year: Int
    var month: Int
    
    // maximum temperature measured in celcius degrees
    var maxTemperature: Double?
    
    // minimum temperature measured in celcius degrees
    var minTemperature: Double?
    
    // airfrost days
    var airFrost: Int?
    
    // total rainfall, mm
    var Rainfall: Double?
    
    // total sunshine duration, hours
    var sunshineDuration : Double?
}

extension Bar: IdentifiableType {
    var identity: Int {
        return (self.year * 100 + self.month).hashValue
    }
}


extension Bar: Equatable {
    static func ==(lhs: Bar, rhs: Bar) -> Bool {
        return lhs.city == rhs.city
            && lhs.year == rhs.year
            && lhs.month == rhs.month
    }
}


