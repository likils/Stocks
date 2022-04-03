// ----------------------------------------------------------------------------
//
//  CompanyProfileRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanyProfileRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(tickerSymbol: String) throws -> CompanyProfileRequest {
        let requestModel = CompanyProfileRequestModel.of(tickerSymbol: tickerSymbol)
        return try CompanyProfileRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
