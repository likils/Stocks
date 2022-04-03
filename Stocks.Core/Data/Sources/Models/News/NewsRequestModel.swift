// ----------------------------------------------------------------------------
//
//  NewsRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct NewsRequestModel: Codable {

    // MARK: - Properties

    let category: NewsCategory
}

// ----------------------------------------------------------------------------

extension NewsRequestModel {

    // MARK: - Construction

    public static func of(category: NewsCategory) -> Self {
        return Self.init(category: category)
    }
}
