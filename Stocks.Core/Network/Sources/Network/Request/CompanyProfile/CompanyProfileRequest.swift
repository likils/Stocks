// ----------------------------------------------------------------------------
//
//  CompanyProfileRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanyProfileRequest: AbstractRequest<CompanyProfileResponseModel> {

    // MARK: - Construction

    init(requestModel: CompanyProfileRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestValueTask<CompanyProfileResponseModel>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
