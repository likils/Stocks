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

    static func create(
        _ baseLink: URL?,
        path: RequestPath? = nil,
        headerFields: [String: String]? = nil,
        queryParams: Data? = nil
    ) throws -> URLRequest {

        guard var link = baseLink else {
            throw UrlRequestFactoryError.malformedLink
        }

        if let path = path {
            link.appendPathComponent(path.rawValue)
        }

        if let queryParams = queryParams {
            try addQueryParamsToLink(&link, queryParams)
        }

        var request = URLRequest(url: link)
        request.allHTTPHeaderFields = headerFields

        return request
    }

// MARK: - Private Methods

    private static func addQueryParamsToLink(_ link: inout URL, _ queryParams: Data) throws {

        var components = URLComponents(url: link, resolvingAgainstBaseURL: true)
        let decodedQueryParams = try JSONDecoder().decode([String: String].self, from: queryParams)

        components?.queryItems = decodedQueryParams.map { URLQueryItem(name: $0.0, value: $0.1) }

        if let componentsLink = components?.url {
            link = componentsLink
        }
        else {
            throw UrlRequestFactoryError.malformedComponentsLink
        }
    }
}
