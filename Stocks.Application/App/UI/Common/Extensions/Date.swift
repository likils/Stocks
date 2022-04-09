// ----------------------------------------------------------------------------
//
//  Date.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

extension Date {

    // MARK: - Properties

    var isRelevant: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    var relativeDateTime: String {
        RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
    }
}
