//
//  CompanyProfile.swift
//  Stocks
//
//  Created by likils on 18.05.2021.
//

import Foundation

struct CompanyProfile: Codable {
    
    // MARK: - JSON properties
    private let currency: String
    private let weburl: String
    private let logo: String
    
    /// Country of company's headquarter.
    let country: String
    
    /// Listed exchange.
    let exchange: String
    
    /// IPO date.
    let ipo: String
    
    /// Market capitalization.
    let marketCapitalization: Double
    
    /// Company name.
    let name: String
    
    /// Company symbol / ticker as used on the listed exchange.
    /// 
    /// Can be used as unique symbol to search company for other queries.
    let ticker: String
    
    // MARK: - Public properties
    /// Company website.
    var webUrl: URL? {
        URL(string: weburl)
    }
    
    /// Logo image url.
    var logoUrl: URL? {
        URL(string: logo)
    }
    
    /// Currency used in company filings.
    var currencyLogo: String {
        switch currency {
            case "USD":
                return "$"
            case "EUR":
                return "€"
            case "GBP":
                return "£"
            case "JPY", "CNY":
                return "¥"
            case "RUB":
                return "₽"
            default:
                return "₪"
        }
    }
    
}
