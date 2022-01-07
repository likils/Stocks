// ----------------------------------------------------------------------------
//
//  WebSocketRequestProvider.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

struct WebSocketRequestProvider: RequestProvider {

// MARK: - Properties

    let link = URL(string: "wss://ws.finnhub.io")!

    let headerFields = [String: String]()

    let path = ""
}
