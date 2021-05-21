//
//  CompanyQuotes.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

struct CompanyQuotes: Codable {
    
    let openPrice: Double
    let highPrice: Double
    let lowPrice: Double
    var currentPrice: Double
    let previousClosePrice: Double
    let timestamp: Double
    
    enum CodingKeys: String, CodingKey {
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case currentPrice = "c"
        case previousClosePrice = "pc"
        case timestamp = "t"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        openPrice = try container.decode(Double.self, forKey: CodingKeys.openPrice)
        highPrice = try container.decode(Double.self, forKey: CodingKeys.highPrice)
        lowPrice = try container.decode(Double.self, forKey: CodingKeys.lowPrice)
        currentPrice = try container.decode(Double.self, forKey: CodingKeys.currentPrice)
        previousClosePrice = try container.decode(Double.self, forKey: CodingKeys.previousClosePrice)
        timestamp = try container.decode(Double.self, forKey: CodingKeys.timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(openPrice, forKey: CodingKeys.openPrice)
        try container.encode(highPrice, forKey: CodingKeys.highPrice)
        try container.encode(lowPrice, forKey: CodingKeys.lowPrice)
        try container.encode(currentPrice, forKey: CodingKeys.currentPrice)
        try container.encode(previousClosePrice, forKey: CodingKeys.previousClosePrice)
        try container.encode(timestamp, forKey: CodingKeys.timestamp)
    }
    
    var date: Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
}
