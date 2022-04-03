// ----------------------------------------------------------------------------
//
//  CurrencyType.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CurrencyType: String, Codable {
    case CNY
    case EUR
    case GBP
    case JPY
    case RUB
    case USD
}

// ----------------------------------------------------------------------------

extension CurrencyType {

    // MARK: - Properties

    public var symbol: String {
        switch self {
            case .CNY, .JPY:
                return "¥"
            case .EUR:
                return "€"
            case .GBP:
                return "£"
            case .RUB:
                return "₽"
            case .USD:
                return "$"
        }
    }
}
