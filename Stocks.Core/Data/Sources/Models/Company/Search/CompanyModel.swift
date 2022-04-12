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

extension CompanyModel {

    // MARK: - Properties

    public var isValid: Bool {
        !self.ticker.contains(".") &&
        !self.name.isEmpty
    }
}
