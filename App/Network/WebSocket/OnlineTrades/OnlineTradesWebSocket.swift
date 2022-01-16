// ----------------------------------------------------------------------------
//
//  OnlineTradesWebSocket.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public final class OnlineTradesWebSocket: AbstractWebSocket<OnlineTradesModel> {

// MARK: - Construction

    init(requestModel: OnlineTradesRequestModel, requestProvider: RequestProvider) throws {

        let requestEntity = try RequestEntity(requestModel: requestModel)
        let urlRequest = UrlRequestFactory.createUrlRequest(requestProvider, requestEntity)

        let webSocketTask = WebSocketValueTask<OnlineTradesModel>(urlRequest: urlRequest)
        super.init(webSocketTask.eraseToAnyWebSocketTask())
    }
}
