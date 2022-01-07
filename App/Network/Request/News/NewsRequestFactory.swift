// ----------------------------------------------------------------------------
//
//  NewsRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum NewsRequestFactory {

// MARK: - Private Properties

    private static let requestProvider = HttpRequestProvider(requestPath: .news)

// MARK: - Methods

    public static func createRequest(newsCategory: NewsCategory) throws -> NewsRequest {

        let requestModel = NewsRequestModel(category: newsCategory)
        return try NewsRequest(requestModel: requestModel, requestProvider: requestProvider)
    }

    public static func createRequest(tickerSymbol: String, periodInDays: Int) throws -> NewsRequest {

        let pastDate = Calendar.current.date(byAdding: .day, value: -periodInDays, to: Date()) ?? Date()
        let requestModel = CompanyNewsRequestModel(tickerSymbol: tickerSymbol, fromDate: pastDate, toDate: Date())

        return try NewsRequest(requestModel: requestModel, requestProvider: requestProvider)
    }
}
