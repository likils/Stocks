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

    public let ticker: String

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
    }
}

// ----------------------------------------------------------------------------

extension CompanyProfileRequestModel {

    // MARK: - Construction

    public static func of(ticker: String) -> Self {
        return Self.init(ticker: ticker)
    }
}
