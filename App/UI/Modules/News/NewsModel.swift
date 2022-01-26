// ----------------------------------------------------------------------------
//
//  NewsModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

struct NewsModel {

// MARK: - Properties

    public let date: Date

    public let headline: String

    public var imageLink: URL?

    public let source: String

    public let sourceLink: URL

    public let summary: String

// MARK: - Construction

    static func of(newsResponse: NewsResponseModel) -> Self {
        return Self.init(
            date: newsResponse.date,
            headline: newsResponse.headline,
            imageLink: newsResponse.imageLink,
            source: newsResponse.source,
            sourceLink: newsResponse.sourceLink,
            summary: newsResponse.summary
        )
    }
}
