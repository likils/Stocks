// ----------------------------------------------------------------------------
//
//  CompanySearchRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CompanySearchRequestModel: Codable {

// MARK: - Properties

    public let searchSymbol: String

// MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case searchSymbol = "q"
    }
}
