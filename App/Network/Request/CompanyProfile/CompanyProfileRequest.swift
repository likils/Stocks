// ----------------------------------------------------------------------------
//
//  CompanyProfileRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public final class CompanyProfileRequest: AbstractRequest<CompanyProfileModel> {

    // MARK: - Construction

    init(requestModel: CompanyProfileRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestDataTask<CompanyProfileModel>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
