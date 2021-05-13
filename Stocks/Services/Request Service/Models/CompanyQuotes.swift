//
//  CompanyQuotes.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

struct CompanyQuotes: Decodable {
    
    let openPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let currentPrice: Double
    let previousClosePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case currentPrice = "c"
        case previousClosePrice = "pc"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        openPrice = try container.decode(Double.self, forKey: CodingKeys.openPrice)
        highPrice = try container.decode(Double.self, forKey: CodingKeys.highPrice)
        lowPrice = try container.decode(Double.self, forKey: CodingKeys.lowPrice)
        currentPrice = try container.decode(Double.self, forKey: CodingKeys.currentPrice)
        previousClosePrice = try container.decode(Double.self, forKey: CodingKeys.previousClosePrice)
    }
    
}
