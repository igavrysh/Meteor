//
//  MetofficeService.swift
//  Meteor
//
//  Created by Gavrysh on 8/7/17.
//  Copyright © 2017 Ievgen Gavrysh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MetofficeService: BarServiceType {
    
    // MARK: - Static Vars
    fileprivate static let emptyBar
        = Bar(city: "EmptyBar",
              year: -1,
              month: -1,
              maxTemperature: nil,
              minTemperature: nil,
              airFrost: nil,
              rainfall: nil,
              sunshineDuration: nil)
    
    // MARK: - API Addresses
    fileprivate enum Address: String {
        case bradford = "bradforddata.txt"
        
        private var baseURL: String { return "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/" }
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API errors
    enum ApiError: Error {
        case responseNotUTF8Convertable
    }
    
    func bars() -> Observable<[Bar]> {
        return self.request(address: .bradford).map {
            guard let barsString = String(data: $0, encoding: .utf8) else {
                throw ApiError.responseNotUTF8Convertable
            }

            let cityNamePattern = "^([\\w\\-]+)"
            let cityNameMatches = MetofficeService.matches(for: cityNamePattern, in: barsString)
            let city = cityNameMatches.first ?? ""
            
            let decimal = "\\d+"
            let lineStartOrSpacing = "(\\s|^)"
            let spacing = "\\s+"
            let double = "[+-]?([0-9]*[.])?[0-9]+"
            let valueWithStarOrMissing: (String) -> String = { "(---|\($0)[*]*)" }
            let doubleStarOrMissing = valueWithStarOrMissing(double)
            let decimalStarOrMissing = valueWithStarOrMissing(decimal)
            
            let barsPattern = "("
                + lineStartOrSpacing
                // year, e.g. 2017
                + decimal
                + spacing
                // month, e.g. 1 or 12
                + decimal
                + spacing
                // temperature max, C
                + doubleStarOrMissing
                + spacing
                // tempaerature min, C
                + doubleStarOrMissing
                + spacing
                // air frost, days
                + decimalStarOrMissing
                + spacing
                // rain, mm
                + doubleStarOrMissing
                + spacing
                // sun, hours
                + doubleStarOrMissing
                + ")"
        
            
            return MetofficeService.matches(for: barsPattern, in: barsString)
                .map { barString in
                    let barPattern = "([^\\s|*]+)"
                    let barMatches = MetofficeService.matches(for: barPattern, in: barString)
                    
                    return barMatches.count != 7
                        ? MetofficeService.emptyBar
                        : Bar(city: city,
                              year: Int(barMatches[0]) ?? -1,
                              month: Int(barMatches[1]) ?? -1,
                              maxTemperature: Double(barMatches[2]),
                              minTemperature: Double(barMatches[3]),
                              airFrost: Int(barMatches[4]),
                              rainfall: Double(barMatches[5]),
                              sunshineDuration: Double(barMatches[6]))
                    
                }
                .filter { $0.year > 0 && $0.month > 0 }
        }
    }
    
    static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }
    }
    
    private func request(address: Address) -> Observable<Data> {
        let request = URLRequest(url: address.url)
        
        return URLSession.shared.rx.data(request: request)
    }
}
