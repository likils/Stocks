// ----------------------------------------------------------------------------
//
//  CompanyQuotesRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanyQuotesRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(ticker: String) throws -> CompanyQuotesRequest {
        let requestModel = CompanyProfileRequestModel.of(ticker: ticker)
        return try CompanyQuotesRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
