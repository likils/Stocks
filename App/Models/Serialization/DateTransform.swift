// ----------------------------------------------------------------------------
//
//  DateTransform.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import CodableWrappers
import Foundation

// ----------------------------------------------------------------------------

public enum DateTransform: StaticCoder {

// MARK: - Methods

    public static func decode(from decoder: Decoder) throws -> Date {

        let dateString = try String(from: decoder)
        let dateFormatter = createDateFormatter()

        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        else {
            let description = "Could not create date from: \(dateString)"
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: description)
            throw DecodingError.valueNotFound(self, context)
        }
    }

    public static func encode(value: Date, to encoder: Encoder) throws {

        let formatter = createDateFormatter()
        let dateString = formatter.string(from: value)

        return try dateString.encode(to: encoder)
    }

// MARK: - Private Methods

    private static func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

// ----------------------------------------------------------------------------

public typealias DateCoding = CodingUses<DateTransform>
