// ----------------------------------------------------------------------------
//
//  NewsResponseModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct NewsResponseModel: Codable, Equatable {

    // MARK: - Properties

    public let category: String
    
    @Immutable @TimestampCoding
    public var date: Date

    public let headline: String

    public let id: Int

    @Immutable @OptionalURLCoding
    public var imageLink: URL?

    public let related: String

    public let source: String

    public let sourceLink: URL

    public let summary: String
    
    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case category
        case date = "datetime"
        case headline
        case id
        case imageLink = "image"
        case related
        case source
        case sourceLink = "url"
        case summary
    }
}
