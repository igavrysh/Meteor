//
//  String.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation

extension String {
    static func monthShortcut(no month: Int) -> String {
        let reverse = DateFormatter()
        reverse.dateFormat = "MM"
        guard let date = reverse.date(from: String(month))  else {
            return "NA"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        
        return  formatter.string(from: date).uppercased()
    }
}
