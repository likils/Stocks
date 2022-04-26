// ----------------------------------------------------------------------------
//
//  CompanyCandlesTimeline.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum CompanyCandlesTimeline: String, CaseIterable, RawRepresentable {
    case day = "D"
    case week = "W"
    case month = "M"
    case year = "Y"
    case all = "All"
}

// ----------------------------------------------------------------------------

extension CompanyCandlesTimeline {

    // MARK: - Properties

    public var caseIndex: Int {
        let caseIndex: Int

        switch self {
            case .day:
                caseIndex = 0
            case .week:
                caseIndex = 1
            case .month:
                caseIndex = 2
            case .year:
                caseIndex = 3
            case .all:
                caseIndex = 4
        }

        return caseIndex
    }

    public var pastDate: Date {
        let pastDate: Date?

        switch self {
            case .day:
                pastDate = Calendar.current.startOfDay(for: Date())
            case .week:
                pastDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            case .month:
                pastDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            case .year:
                pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
            case .all:
                pastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        }

        return pastDate ?? Calendar.current.startOfDay(for: Date())
    }

    public var resolution: CandlesResolution {
        switch self {
            case .day:
                return .minute
            case .week:
                return .minutes_15
            case .month:
                return .minutes_60
            case .year:
                return .day
            case .all:
                return .month
        }
    }
}
