// ----------------------------------------------------------------------------
//
//  UrlRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

enum UrlRequestFactory {

    // MARK: - Methods

    static func createUrlRequest(
        _ provider: RequestProvider,
        _ entity: RequestEntity
    ) -> URLRequest {

        var link = provider.link
        link.appendPathComponent(provider.path)

        let queryItems = entity.queryItems
        addQueryItemsToLink(&link, queryItems)

        var request = URLRequest(url: link)
        request.allHTTPHeaderFields = provider.headerFields

        return request
    }

    // MARK: - Private Methods

    private static func addQueryItemsToLink(_ link: inout URL, _ queryItems: [String: String]) {

        var components = URLComponents(url: link, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: $0.1) }

        if let componentsLink = components?.url {
            link = componentsLink
        }
    }
}
