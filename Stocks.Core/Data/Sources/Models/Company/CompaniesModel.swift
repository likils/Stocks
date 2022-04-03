// ----------------------------------------------------------------------------
//
//  CompaniesModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct CompaniesModel: Codable {

    // MARK: - Properties

    public let companies: [CompanyModel]

    public let count: Int

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case companies = "result"
        case count
    }
}
