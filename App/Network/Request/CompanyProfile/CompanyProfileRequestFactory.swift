// ----------------------------------------------------------------------------
//
//  CompanyProfileRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CompanyProfileRequestFactory {

// MARK: - Private Properties

    private static let requestProvider = HttpRequestProvider(requestPath: .companyProfile)

// MARK: - Methods

    public static func createRequest(tickerSymbol: String) throws -> CompanyProfileRequest {
        let requestModel = CompanyProfileRequestModel(tickerSymbol: tickerSymbol)
        return try CompanyProfileRequest(requestModel: requestModel, requestProvider: requestProvider)
    }
}
