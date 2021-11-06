// ----------------------------------------------------------------------------
//
//  CandlesTimelineType.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CandlesTimelineType: String, CaseIterable, RawRepresentable {
    case day = "D"
    case week = "W"
    case month = "M"
    case year = "Y"
    case all = "All"
}

// ----------------------------------------------------------------------------

extension CandlesTimelineType {

// MARK: - Properties

    public var description: String {
        switch self {
            case .day:
                return "day"
            case .week:
                return "week"
            case .month:
                return "month"
            case .year:
                return "year"
            case .all:
                return "10 years"
        }
    }
}
