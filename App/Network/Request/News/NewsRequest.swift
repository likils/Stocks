// ----------------------------------------------------------------------------
//
//  NewsRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public final class NewsRequest: AbstractRequest<[NewsResponseModel]> {

// MARK: - Construction
    
    init<RequestModel: Codable>(requestModel: RequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let requestTask = RequestValueTask<[NewsResponseModel]>(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }
}
