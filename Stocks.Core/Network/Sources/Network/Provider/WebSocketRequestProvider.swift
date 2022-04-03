// ----------------------------------------------------------------------------
//
//  WebSocketRequestProvider.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import Resolver

// ----------------------------------------------------------------------------

struct WebSocketRequestProvider: RequestProvider {

    // MARK: - Properties

    let link: URL

    let headerFields: [String: String]

    let path: String

    // MARK: - Construction

    init() {
        self.link = Resolver.resolve(name: .webSocketLink)
        self.headerFields = .empty
        self.path = .empty
    }
}
