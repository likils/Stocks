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

    let internalSearchResults: [CompanyModel]

    let externalSearchResults: [CompanyModel]
}

// ----------------------------------------------------------------------------

extension CompanySearchModel {

// MARK: - Construction

    init() {
        self.init(internalSearchResults: .empty, externalSearchResults: .empty)
    }
}
