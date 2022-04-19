// ----------------------------------------------------------------------------
//
//  GraphModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

struct GraphModel {

    // MARK: - Properties

    let prices: [Double]

    let minPrice: Double

    let maxPrice: Double
}

// ----------------------------------------------------------------------------

extension GraphModel {

    // MARK: - Construction

    init() {
        self.prices = []
        self.minPrice = 0
        self.maxPrice = 0
    }
}
