// ----------------------------------------------------------------------------
//
//  CompanyNewsRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct CompanyNewsRequestModel: Codable {

// MARK: - Properties

    public let companySymbol: String

    @Immutable @DateCoding
    public var fromDate: Date

    @Immutable @DateCoding
    public var toDate: Date

// MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case companySymbol = "symbol"
        case fromDate = "from"
        case toDate = "to"
    }
}
