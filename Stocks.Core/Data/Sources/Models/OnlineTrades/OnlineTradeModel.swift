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
    
    public let price: Double
    
    public let ticker: String

    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case price = "p"
        case ticker = "s"
    }
}
