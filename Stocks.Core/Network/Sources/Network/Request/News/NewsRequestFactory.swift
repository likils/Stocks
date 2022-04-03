// ----------------------------------------------------------------------------
//
//  NewsRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class NewsRequestFactory {

    // MARK: - Private Properties

    private let requestProvider: HttpsRequestProvider

    // MARK: - Construction

    init(requestProvider: HttpsRequestProvider) {
        self.requestProvider = requestProvider
    }

    // MARK: - Methods

    public func createRequest(newsCategory: NewsCategory) throws -> NewsRequest {

        let requestModel = NewsRequestModel.of(category: newsCategory)
        return try NewsRequest(requestModel: requestModel, requestProvider: self.requestProvider)
    }
}
