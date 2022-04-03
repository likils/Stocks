// ----------------------------------------------------------------------------
//
//  CompanyNewsRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import StocksData

// ----------------------------------------------------------------------------

public final class CompanyNewsRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(tickerSymbol: String, periodInDays: Int) throws -> NewsRequest {

        let pastDate = Calendar.current.date(byAdding: .day, value: -periodInDays, to: Date()) ?? Date()
        let requestModel = CompanyNewsRequestModel.of(tickerSymbol: tickerSymbol, fromDate: pastDate, toDate: Date())

        return try NewsRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
