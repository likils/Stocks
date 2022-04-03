// ----------------------------------------------------------------------------
//
//  CompanyProfileRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CompanyProfileRequestModel: Codable {

    // MARK: - Properties

    public let tickerSymbol: String

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case tickerSymbol = "symbol"
    }
}

// ----------------------------------------------------------------------------

extension CompanyProfileRequestModel {

    // MARK: - Construction

    public static func of(tickerSymbol: String) -> Self {
        return Self.init(tickerSymbol: tickerSymbol)
    }
}
