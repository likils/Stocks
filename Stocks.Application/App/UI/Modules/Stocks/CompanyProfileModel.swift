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

    let ticker: String

    let websiteLink: URL

    let companyQuotes: CompanyQuotesModel

    let inWatchlist: Bool
}

// ----------------------------------------------------------------------------

extension CompanyProfileModel {

    // MARK: - Construction

    init(companyProfileDataModel: CompanyProfileDataModel, companyQuotes: CompanyQuotesModel) {
        self.init(
            currency: companyProfileDataModel.currency,
            headquarterCountry: companyProfileDataModel.headquarterCountry,
            ipoDate: companyProfileDataModel.ipoDate,
            listedExchange: companyProfileDataModel.listedExchange,
            logoLink: companyProfileDataModel.logoLink,
            marketCapitalization: companyProfileDataModel.marketCapitalization,
            name: companyProfileDataModel.name,
            ticker: companyProfileDataModel.ticker,
            websiteLink: companyProfileDataModel.websiteLink,
            companyQuotes: companyQuotes,
            inWatchlist: companyProfileDataModel.inWatchlist
        )
    }
}
