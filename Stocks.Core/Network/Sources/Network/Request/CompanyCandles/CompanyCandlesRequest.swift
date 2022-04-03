// ----------------------------------------------------------------------------
//
//  CompanyCandlesRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class CompanyCandlesRequest: AbstractRequest<CompanyCandlesModel> {

    // MARK: - Construction

    init(requestModel: CompanyCandlesRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestValueTask<CompanyCandlesModel>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
