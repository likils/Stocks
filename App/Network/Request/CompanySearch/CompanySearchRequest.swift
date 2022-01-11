// ----------------------------------------------------------------------------
//
//  CompanySearchRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public final class CompanySearchRequest: AbstractRequest<CompaniesModel> {

// MARK: - Construction

    init(requestModel: CompanySearchRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestValueTask<CompaniesModel>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
