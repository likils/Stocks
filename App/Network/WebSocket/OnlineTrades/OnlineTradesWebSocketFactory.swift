// ----------------------------------------------------------------------------
//
//  OnlineTradesWebSocketFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum OnlineTradesWebSocketFactory {

// MARK: - Private Properties

    private static let requestProvider = WebSocketRequestProvider()

// MARK: - Methods

    public static func createWebSocket() throws -> OnlineTradesWebSocket {
        let requestModel = OnlineTradesRequestModel(token: NetworkSettings.token)
        return try OnlineTradesWebSocket(requestModel: requestModel, requestProvider: requestProvider)
    }
}
