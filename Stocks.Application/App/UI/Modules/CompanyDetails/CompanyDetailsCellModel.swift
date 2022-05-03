// ----------------------------------------------------------------------------
//
//  CompanyDetailsCellModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData

// ----------------------------------------------------------------------------

struct CompanyDetailsCellModel {

    // MARK: - Properties

    let listener: CompanyDetailsCellListener
    
    let timelines: [CompanyCandlesTimeline]

    let selectedTimeline: CompanyCandlesTimeline

    let companyCandlesPublisher: CompanyCandlesPublisher

    let companyProfilePublisher: CompanyProfilePublisher

    let imagePublisher: ImagePublisher

    let onlineTradePublisher: OnlineTradePublisher
}
