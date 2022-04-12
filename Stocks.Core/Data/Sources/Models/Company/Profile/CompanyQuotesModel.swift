// ----------------------------------------------------------------------------
//
//  CompanyQuotesModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct CompanyQuotesModel: Codable {

    // MARK: - Properties

    public let currentPrice: Double

    @Immutable @TimestampCoding
    public var date: Date

    public let highPrice: Double

    public let lowPrice: Double

    public let openPrice: Double

    public let previousClosePrice: Double

    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case date = "t"
        case highPrice = "h"
        case lowPrice = "l"
        case openPrice = "o"
        case previousClosePrice = "pc"
    }
}
