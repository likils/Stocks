// ----------------------------------------------------------------------------
//
//  CompanyProfileDataModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public struct CompanyProfileDataModel: Codable {

    // MARK: - Properties

    public let currency: CurrencyType

    public let headquarterCountry: String

    public let ipoDate: String

    public let listedExchange: String

    public let logoLink: URL

    public let marketCapitalization: Double

    public let name: String

    public let ticker: String

    public let websiteLink: URL

    public let inWatchlist: Bool
}

// ----------------------------------------------------------------------------

extension CompanyProfileDataModel {

    // MARK: - Construction

    public init(companyProfile: CompanyProfileResponseModel, inWatchlist: Bool) {
        self.init(
            currency: companyProfile.currency,
            headquarterCountry: companyProfile.headquarterCountry,
            ipoDate: companyProfile.ipoDate,
            listedExchange: companyProfile.listedExchange,
            logoLink: companyProfile.logoLink,
            marketCapitalization: companyProfile.marketCapitalization,
            name: companyProfile.name,
            ticker: companyProfile.ticker,
            websiteLink: companyProfile.websiteLink,
            inWatchlist: inWatchlist
        )
    }

    // MARK: - Methods

    public func patch(inWatchlist: Bool) -> Self {
        CompanyProfileDataModel(
            currency: self.currency,
            headquarterCountry: self.headquarterCountry,
            ipoDate: self.ipoDate,
            listedExchange: self.listedExchange,
            logoLink: self.logoLink,
            marketCapitalization: self.marketCapitalization,
            name: self.name,
            ticker: self.ticker,
            websiteLink: self.websiteLink,
            inWatchlist: inWatchlist
        )
    }
}
