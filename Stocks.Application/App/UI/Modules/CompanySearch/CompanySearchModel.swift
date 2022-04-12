// ----------------------------------------------------------------------------
//
//  CompanySearchModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

struct CompanySearchModel {

    // MARK: - Properties

    let name: String

    let ticker: String

    let inWatchList: Bool
}

// ----------------------------------------------------------------------------

extension CompanySearchModel {

    // MARK: - Construction

    init(companyModel: CompanyModel, inWatchlist: Bool) {
        self.init(name: companyModel.name, ticker: companyModel.ticker, inWatchList: inWatchlist)
    }
}
