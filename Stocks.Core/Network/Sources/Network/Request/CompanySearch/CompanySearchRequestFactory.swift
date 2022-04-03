// ----------------------------------------------------------------------------
//
//  SearchCompanyRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanySearchRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(searchSymbol: String) throws -> CompanySearchRequest {
        let requestModel = CompanySearchRequestModel.of(searchSymbol: searchSymbol)
        return try CompanySearchRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
