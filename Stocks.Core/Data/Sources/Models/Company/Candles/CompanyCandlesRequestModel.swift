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

    public let ticker: String

    public let resolution: CandlesResolution

    @Immutable @TimestampCoding
    public var fromDate: Date

    @Immutable @TimestampCoding
    public var toDate: Date

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case resolution
        case fromDate = "from"
        case toDate = "to"
    }
}

// ----------------------------------------------------------------------------

extension CompanyCandlesRequestModel {

    // MARK: - Construction

    public static func of(
        ticker: String,
        resolution: CandlesResolution,
        fromDate: Date,
        toDate: Date
    ) -> Self {

        return Self.init(
            ticker: ticker,
            resolution: resolution,
            fromDate: fromDate,
            toDate: toDate
        )
    }
}
