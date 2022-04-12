// ----------------------------------------------------------------------------
//
//  CompanyCandlesRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import StocksData

// ----------------------------------------------------------------------------

public final class CompanyCandlesRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(ticker: String, timeline: CompanyCandlesTimeline) throws -> CompanyCandlesRequest {

        let requestModel = CompanyCandlesRequestModel.of(
            ticker: ticker,
            resolution: timeline.resolution,
            fromDate: timeline.pastDate,
            toDate: Date()
        )
        return try CompanyCandlesRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
