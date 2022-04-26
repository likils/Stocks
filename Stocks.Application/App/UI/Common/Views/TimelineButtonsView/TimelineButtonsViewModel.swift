// ----------------------------------------------------------------------------
//
//  TimelineButtonsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

struct TimelineButtonsViewModel {

// MARK: - Properties

    let timelines: [CompanyCandlesTimeline]

    let selectedTimeline: CompanyCandlesTimeline

    let listener: TimelineButtonsViewListener
}
