// ----------------------------------------------------------------------------
//
//  Timestamp.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public enum Timestamp: StaticCoder {

// MARK: - Methods

    public static func decode(from decoder: Decoder) throws -> Date {
        let timestamp = try Double(from: decoder)
        return Date(timeIntervalSince1970: timestamp)
    }

    public static func encode(value: Date, to encoder: Encoder) throws {
        let timestamp = value.timeIntervalSince1970
        return try timestamp.encode(to: encoder)
    }
}

// ----------------------------------------------------------------------------

public typealias TimestampCoding = CodingUses<Timestamp>
