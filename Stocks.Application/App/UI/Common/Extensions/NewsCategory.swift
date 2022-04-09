// ----------------------------------------------------------------------------
//
//  NewsCategory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData
import UIKit

// ----------------------------------------------------------------------------

extension NewsCategory {

    // MARK: - Properties

    var minWidthForText: CGFloat {
        switch self {
            case .general:
                return 94.0

            case .forex:
                return 80.0

            case .crypto:
                return 86.0

            case .merger:
                return 90.0
        }
    }

    var text: String {
        switch self {
            case .crypto:
                return "💰Crypto"

            case .forex:
                return "📈Forex"

            case .general:
                return "👋🏻General"

            case .merger:
                return "👔Merger"
        }
    }
}
