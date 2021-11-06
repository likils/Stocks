// ----------------------------------------------------------------------------
//
//  OnlineTradeModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct OnlineTradeModel: Codable {

// MARK: - Properties
    
    public var price: Double
    
    public var ticker: String

// MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case price = "p"
        case ticker = "s"
    }
}
