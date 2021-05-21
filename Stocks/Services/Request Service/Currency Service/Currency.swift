//
//  Currency.swift
//  Stocks
//
//  Created by likils on 11.04.2021.
//

import Foundation

struct Currency: Decodable {
    
    var base: String
    var quote: [String: Double]
    
}
