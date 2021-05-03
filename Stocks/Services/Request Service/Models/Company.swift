//
//  Company.swift
//  Stocks
//
//  Created by likils on 03.05.2021.
//

import Foundation

struct Company: Decodable {
    
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
    
}

struct SearchedCompanies: Decodable {
    
    let count: Int
    let result: [Company]
    
}
