//
//  Company.swift
//  Stocks
//
//  Created by likils on 03.05.2021.
//

import Foundation

struct Company: Decodable, Hashable, Comparable {
    
    /// Company name.
    let description: String
    
    /// Company symbol / ticker as used on the listed exchange.
    /// 
    /// Can be used as unique symbol to search company for other queries.
    let symbol: String
    
    static func < (lhs: Company, rhs: Company) -> Bool {
        lhs.symbol.localizedCaseInsensitiveCompare(rhs.symbol) == .orderedAscending
    }
    
}

struct SearchedCompanies: Decodable {
    
    let count: Int
    let result: [Company]
    
}
