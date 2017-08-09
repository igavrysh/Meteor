//
//  BarsServiceType.swift
//  Meteor
//
//  Created by Gavrysh on 8/8/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation
import RxSwift

protocol BarServiceType {
    func bars() -> Observable<[Bar]>
}
