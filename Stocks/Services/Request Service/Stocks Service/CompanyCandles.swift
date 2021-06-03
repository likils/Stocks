//
//  CompanyCandles.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import Foundation

struct CompanyCandles: Decodable {
    
    // MARK: - Candles query
    enum TimeLine: String, CaseIterable, RawRepresentable {
        case day = "D"
        case week = "W"
        case month = "M"
        case year = "Y"
        case all = "ALL"
        
        var query: [String: String] {
            let pastDate: Date
            let resolution: Resolution
            
            switch self {
                case .day:
                    resolution = .minute
                    pastDate = Calendar.current.startOfDay(for: Date())
                case .week:
                    resolution = .minutes_15
                    pastDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                case .month:
                    resolution = .minutes_60
                    pastDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
                case .year:
                    resolution = .day
                    pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
                case .all:
                    resolution = .month
                    pastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
            }
            
            // convert to UNIX timestamp
            let past = Int(pastDate.timeIntervalSince1970)
            let current = Int(Date().timeIntervalSince1970)
            
            return ["resolution": resolution.rawValue,
                    "from": String(past),
                    "to": String(current)]
        }
        
        /// Title for text
        var title: String {
            switch self {
                case .day:
                    return "day"
                case .week:
                    return "week"
                case .month:
                    return "month"
                case .year:
                    return "year"
                case .all:
                    return "10 years"
            }
        }
        
        private enum Resolution: String {
            case minute = "1"
            case minutes_5 = "5"
            case minutes_15 = "15"
            case minutes_30 = "30"
            case minutes_60 = "60"
            case day = "D"
            case week = "W"
            case month = "M"
        }
    }
    
    // MARK: - Public properties
    let openPrices: [Double]
    let highPrices: [Double]
    let lowPrices: [Double]
    let closePrices: [Double]
    let timestamps: [Double]
    let volumeData: [Double]
    let responseStatus: String
    
    // MARK: - JSON Decoding
    enum CodingKeys: String, CodingKey {
        case openPrices = "o"
        case highPrices = "h"
        case lowPrices = "l"
        case closePrices = "c"
        case timestamps = "t"
        case volumeData = "v"
        case responseStatus = "s"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        openPrices = try container.decode([Double].self, forKey: CodingKeys.openPrices)
        highPrices = try container.decode([Double].self, forKey: CodingKeys.highPrices)
        lowPrices = try container.decode([Double].self, forKey: CodingKeys.lowPrices)
        closePrices = try container.decode([Double].self, forKey: CodingKeys.closePrices)
        timestamps = try container.decode([Double].self, forKey: CodingKeys.timestamps)
        volumeData = try container.decode([Double].self, forKey: CodingKeys.volumeData)
        responseStatus = try container.decode(String.self, forKey: CodingKeys.responseStatus)
    }
    
}
