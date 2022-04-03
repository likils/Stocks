// ----------------------------------------------------------------------------
//
//  CompanyCandlesModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CompanyCandlesModel: Codable {
    
    // MARK: - Properties

    public let closePrices: [Double]

    public let highPrices: [Double]

    public let lowPrices: [Double]

    public let openPrices: [Double]

    public let responseStatus: String

    public let timestamps: [Double]

    public let volumeData: [Double]
    
    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case closePrices = "c"
        case highPrices = "h"
        case lowPrices = "l"
        case openPrices = "o"
        case responseStatus = "s"
        case timestamps = "t"
        case volumeData = "v"
    }
}
