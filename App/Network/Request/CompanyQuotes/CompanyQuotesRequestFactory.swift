// ----------------------------------------------------------------------------
//
//  CompanyQuotesRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CompanyQuotesRequestFactory {

// MARK: - Private Properties

    private static let requestProvider = HttpRequestProvider(requestPath: .companyQuotes)

// MARK: - Methods

    public static func createRequest(tickerSymbol: String) throws -> CompanyQuotesRequest {
        let requestModel = CompanyProfileRequestModel(tickerSymbol: tickerSymbol)
        return try CompanyQuotesRequest(requestModel: requestModel, requestProvider: requestProvider)
    }
}
