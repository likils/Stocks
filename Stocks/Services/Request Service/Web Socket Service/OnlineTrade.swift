//
//  OnlineTrade.swift
//  Stocks
//
//  Created by likils on 20.05.2021.
//

import Foundation

struct OnlineTrade: Decodable, Equatable {
    
    var price: Double
    var ticker: String
    
    enum CodingKeys: String, CodingKey {
        case price = "p"
        case ticker = "s"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        price = try container.decode(Double.self, forKey: CodingKeys.price)
        ticker = try container.decode(String.self, forKey: CodingKeys.ticker)
    }
    
    static func == (lhs: OnlineTrade, rhs: OnlineTrade) -> Bool {
        lhs.ticker == rhs.ticker
    }
    
}

struct OnlineTrades: Decodable {
    var data: [OnlineTrade]
}
