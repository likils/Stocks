// ----------------------------------------------------------------------------
//
//  CompanyCandlesRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct CompanyCandlesRequestModel: Codable {

    // MARK: - Properties

    public let tickerSymbol: String

    public let resolution: CandlesResolution

    @Immutable @TimestampCoding
    public var fromDate: Date

    @Immutable @TimestampCoding
    public var toDate: Date

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case tickerSymbol = "symbol"
        case resolution
        case fromDate = "from"
        case toDate = "to"
    }
}

// ----------------------------------------------------------------------------

extension CompanyCandlesRequestModel {

    // MARK: - Construction

    public static func of(
        tickerSymbol: String,
        resolution: CandlesResolution,
        fromDate: Date,
        toDate: Date
    ) -> Self {

        return Self.init(
            tickerSymbol: tickerSymbol,
            resolution: resolution,
            fromDate: fromDate,
            toDate: toDate
        )
    }
}
