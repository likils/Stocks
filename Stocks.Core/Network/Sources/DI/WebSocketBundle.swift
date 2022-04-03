// ----------------------------------------------------------------------------
//
//  WebSocketBundle.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Resolver

// ----------------------------------------------------------------------------

extension Resolver {

    // MARK: - Methods

    public static func registerWebSocket() {
        Resolver.defaultScope = .shared

        register {
            OnlineTradesWebSocketContainer(requestProvider: .init(), token: resolve(name: .token))
        }
    }
}
