// ----------------------------------------------------------------------------
//
//  OnlineTradesWebSocketContainer.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

public final class OnlineTradesWebSocketContainer {

    // MARK: - Private Properties

    private let requestProvider: WebSocketRequestProvider
    private let token: String
    private var webSocket: OnlineTradesWebSocket?

    // MARK: - Construction

    init(requestProvider: WebSocketRequestProvider, token: String) {
        self.requestProvider = requestProvider
        self.token = token
    }

    // MARK: - Methods

    public func getWebSocket() throws -> OnlineTradesWebSocket {
        return try self.webSocket ?? createAndStoreWebSocket()
    }

    // MARK: - Private Methods

    private func createAndStoreWebSocket() throws -> OnlineTradesWebSocket {
        let requestModel = OnlineTradesRequestModel.of(token: self.token)
        let webSocket = try OnlineTradesWebSocket(requestModel: requestModel, requestProvider: self.requestProvider)
        self.webSocket = webSocket
        return webSocket
    }
}
