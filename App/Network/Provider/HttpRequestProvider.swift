// ----------------------------------------------------------------------------
//
//  HttpRequestProvider.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

struct HttpRequestProvider: RequestProvider {

// MARK: - Construction

    init(requestPath: RequestPath) {
        path = requestPath.rawValue
    }

// MARK: - Properties

    let link = URL(string:"https://finnhub.io/api/v1/")!

    let headerFields = ["X-Finnhub-Token": RequestSettings.token]

    let path: String
}
