// ----------------------------------------------------------------------------
//
//  CompanyModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CompanyModel: Codable {

    // MARK: - Properties

    public let name: String

    public let ticker: String

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case name = "description"
        case ticker = "symbol"
    }
}

// ----------------------------------------------------------------------------

extension CompanyModel {

    // MARK: - Construction

    @available(*, deprecated, message: "must be removed")
    public static func of(name: String, ticker: String) -> Self {
        return Self.init(name: name, ticker: ticker)
    }
}
