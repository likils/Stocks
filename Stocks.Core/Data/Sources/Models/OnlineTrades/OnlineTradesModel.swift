// ----------------------------------------------------------------------------
//
//  OnlineTradesModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct OnlineTradesModel: Codable {

    // MARK: - Properties

    public let onlineTrades: [OnlineTradeModel]

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case onlineTrades = "data"
    }
}

// ----------------------------------------------------------------------------

extension OnlineTradesModel {

    // MARK: - Public Methods

    @available(*, deprecated, message: "Remove after online trades request refactoring.")
    public func compress() -> Self {

        var onlineTrades = [String: Double]()
        self.onlineTrades.forEach { onlineTrades[$0.ticker] = $0.price }

        let onlineTradeModels = onlineTrades.map { OnlineTradeModel(price: $1, ticker: $0) }

        return OnlineTradesModel(onlineTrades: onlineTradeModels)
    }
}
