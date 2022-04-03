// ----------------------------------------------------------------------------
//
//  NewsModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import StocksData

// ----------------------------------------------------------------------------

struct NewsModel {

    // MARK: - Properties

    let date: Date

    let headline: String

    let imageLink: URL?

    let source: String

    let sourceLink: URL

    let summary: String
}

// ----------------------------------------------------------------------------

extension NewsModel {

    // MARK: - Construction

    init(newsResponse: NewsResponseModel) {
        self.init(
            date: newsResponse.date,
            headline: newsResponse.headline,
            imageLink: newsResponse.imageLink,
            source: newsResponse.source,
            sourceLink: newsResponse.sourceLink,
            summary: newsResponse.summary
        )
    }
}
