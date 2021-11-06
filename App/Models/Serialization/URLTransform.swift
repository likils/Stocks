// ----------------------------------------------------------------------------
//
//  URLTransform.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public struct URLTransform: StaticCoder {

// MARK: - Methods

    public static func decode(from decoder: Decoder) throws -> URL {
        let urlString = try String(from: decoder)

        if let url = URL(string: urlString) {
            return url
        }
        else {
            let description = "Could not create URL from: \(urlString)"
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(self, context)
        }
    }

    public static func encode(value: URL, to encoder: Encoder) throws {
        let urlString = value.absoluteString

        var container = encoder.singleValueContainer()
        try container.encode(urlString)
    }
}

// ----------------------------------------------------------------------------

public typealias URLCoding = CodingUses<URLTransform>

public typealias OptionalURLCoding = OptionalCoding<URLCoding>
