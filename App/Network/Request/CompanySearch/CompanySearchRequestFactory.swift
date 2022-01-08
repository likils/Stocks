// ----------------------------------------------------------------------------
//
//  SearchCompanyRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CompanySearchRequestFactory {

// MARK: - Private Properties

    private static let requestProvider = HttpRequestProvider(requestPath: .companySearch)

// MARK: - Methods

    public static func createRequest(searchSymbol: String) throws -> CompanySearchRequest {
        let requestModel = CompanySearchRequestModel(searchSymbol: searchSymbol)
        return try CompanySearchRequest(requestModel: requestModel, requestProvider: requestProvider)
    }
}
