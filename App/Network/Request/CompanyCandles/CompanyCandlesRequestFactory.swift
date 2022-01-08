// ----------------------------------------------------------------------------
//
//  CompanyCandlesRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum CompanyCandlesRequestFactory {

    // MARK: - Private Properties

    private static let requestProvider = HttpRequestProvider(requestPath: .companyCandles)

    // MARK: - Methods

    public static func createRequest(tickerSymbol: String, timeline: CompanyCandlesTimeline) throws -> CompanyCandlesRequest {

        let requestModel = CompanyCandlesRequestModel(
            tickerSymbol: tickerSymbol,
            resolution: timeline.resolution,
            fromDate: timeline.pastDate,
            toDate: Date()
        )
        return try CompanyCandlesRequest(requestModel: requestModel, requestProvider: requestProvider)
    }
}
