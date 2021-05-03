//
//  CompanyQuotes.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

struct CompanyQuotes: Decodable {
    
    let openPrice: Float
    let highPrice: Float
    let lowPrice: Float
    let currentPrice: Float
    let previousClosePrice: Float
    
    enum CodingKeys: String, CodingKey {
        case openPrice = "o"
        case highPrice = "h"
        case lowPrice = "l"
        case currentPrice = "c"
        case previousClosePrice = "pc"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        openPrice = try container.decode(Float.self, forKey: CodingKeys.openPrice)
        highPrice = try container.decode(Float.self, forKey: CodingKeys.highPrice)
        lowPrice = try container.decode(Float.self, forKey: CodingKeys.lowPrice)
        currentPrice = try container.decode(Float.self, forKey: CodingKeys.currentPrice)
        previousClosePrice = try container.decode(Float.self, forKey: CodingKeys.previousClosePrice)
    }
    
}
