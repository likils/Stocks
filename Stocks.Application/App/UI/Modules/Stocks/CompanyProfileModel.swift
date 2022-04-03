// ----------------------------------------------------------------------------
//
//  CompanyProfileModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import StocksData

// ----------------------------------------------------------------------------

struct CompanyProfileModel {

    // MARK: - Properties

    let currency: CurrencyType

    let headquarterCountry: String

    let ipoDate: String

    let listedExchange: String

    let logoLink: URL

    let marketCapitalization: Double

    let name: String

    let tickerSymbol: String

    let websiteLink: URL

    let companyQuotes: CompanyQuotesModel

    let inWatchlist: Bool
}

// ----------------------------------------------------------------------------

extension CompanyProfileModel {

    // MARK: - Construction

    init(companyProfile: CompanyProfileResponseModel, companyQuotes: CompanyQuotesModel, inWatchlist: Bool) {
        self.init(
            currency: companyProfile.currency,
            headquarterCountry: companyProfile.headquarterCountry,
            ipoDate: companyProfile.ipoDate,
            listedExchange: companyProfile.listedExchange,
            logoLink: companyProfile.logoLink,
            marketCapitalization: companyProfile.marketCapitalization,
            name: companyProfile.name,
            tickerSymbol: companyProfile.tickerSymbol,
            websiteLink: companyProfile.websiteLink,
            companyQuotes: companyQuotes,
            inWatchlist: inWatchlist
        )
    }
}
