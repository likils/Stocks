// ----------------------------------------------------------------------------
//
//  CompanyNewsRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct CompanyNewsRequestModel: Codable {
    
    // MARK: - Properties
    
    public let tickerSymbol: String
    
    @Immutable @DateCoding
    public var fromDate: Date
    
    @Immutable @DateCoding
    public var toDate: Date
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case tickerSymbol = "symbol"
        case fromDate = "from"
        case toDate = "to"
    }
}

// ----------------------------------------------------------------------------

extension CompanyNewsRequestModel {
    
    // MARK: - Construction
    
    public static func of(tickerSymbol: String, fromDate: Date, toDate: Date) -> Self {
        return Self.init(tickerSymbol: tickerSymbol, fromDate: fromDate, toDate: toDate)
    }
}
