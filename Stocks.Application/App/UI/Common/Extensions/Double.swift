// ----------------------------------------------------------------------------
//
//  Double.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

extension Double {

// MARK: - Properties

    var textRepresentation: String {
        String(format: "%.2f", self).replacingOccurrences(of: ".", with: ",")
    }
}
