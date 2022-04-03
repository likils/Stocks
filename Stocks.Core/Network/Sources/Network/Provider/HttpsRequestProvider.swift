// ----------------------------------------------------------------------------
//
//  HttpsRequestProvider.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import Resolver

// ----------------------------------------------------------------------------

struct HttpsRequestProvider: RequestProvider {

    // MARK: - Properties

    let link: URL

    let headerFields: [String: String]

    let path: String

    // MARK: - Construction

    init(requestPath: RequestPath) {
        self.link = Resolver.resolve(name: .httpsLink)
        self.headerFields = ["X-Finnhub-Token": Resolver.resolve(name: .token)]
        self.path = requestPath.rawValue
    }
}
