// ----------------------------------------------------------------------------
//
//  CurrencyModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CurrencyModel: Codable {

// MARK: - Properties
    
    public let baseCurrency: CurrencyType

    public let quoteRates: [CurrencyType: Double]

// MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case baseCurrency = "base"
        case quoteRates = "quote"
    }
}
