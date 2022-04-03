// ----------------------------------------------------------------------------
//
//  CompanyProfileResponseModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public struct CompanyProfileResponseModel: Codable {

    // MARK: - Properties

    public let currency: CurrencyType

    public let headquarterCountry: String

    public let ipoDate: String

    public let listedExchange: String

    public let logoLink: URL

    public let marketCapitalization: Double

    public let name: String

    public let tickerSymbol: String

    public let websiteLink: URL

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case currency
        case headquarterCountry = "country"
        case ipoDate = "ipo"
        case listedExchange = "exchange"
        case logoLink = "logo"
        case marketCapitalization
        case name
        case tickerSymbol = "ticker"
        case websiteLink = "weburl"
    }
}
