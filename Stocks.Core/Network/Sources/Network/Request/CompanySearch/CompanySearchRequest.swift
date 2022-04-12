// ----------------------------------------------------------------------------
//
//  CompanySearchRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanySearchRequest: AbstractRequest<CompaniesResponseModel> {

    // MARK: - Construction

    init(requestModel: CompanySearchRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestValueTask<CompaniesResponseModel>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
