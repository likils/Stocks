// ----------------------------------------------------------------------------
//
//  SettingsBundle.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import Resolver

// ----------------------------------------------------------------------------

extension Resolver {

    // MARK: - Methods

    static func registerSettings() {

        register(name: .token) { "c1o6ggq37fkqrr9safcg" }
        register(URL.self, name: .httpsLink) { URL.of(string:"https://finnhub.io/api/v1/") }
        register(URL.self, name: .webSocketLink) { URL.of(string: "wss://ws.finnhub.io") }
    }
}
