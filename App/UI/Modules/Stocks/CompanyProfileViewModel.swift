// ----------------------------------------------------------------------------
//
//  CompanyProfileViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

struct CompanyProfileViewModel: Codable {

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

    let companyQuotes: CompanyQuotesModel?

    let inWatchlist: Bool
}

extension CompanyProfileViewModel {

// MARK: - Construction

    init(companyProfile: CompanyProfileModel, inWatchlist: Bool) {
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
            companyQuotes: nil,
            inWatchlist: inWatchlist
        )
    }

// MARK: - Public Methods

    func copy(with companyQuotes: CompanyQuotesModel?) -> Self {

        return CompanyProfileViewModel(
            currency: self.currency,
            headquarterCountry: self.headquarterCountry,
            ipoDate: self.ipoDate,
            listedExchange: self.listedExchange,
            logoLink: self.logoLink,
            marketCapitalization: self.marketCapitalization,
            name: self.name,
            ticker: self.ticker,
            websiteLink: self.websiteLink,
            companyQuotes: companyQuotes,
            inWatchlist: self.inWatchlist
        )
    }
}
