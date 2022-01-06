// ----------------------------------------------------------------------------
//
//  RequestSettings.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

enum RequestSettings {
    
    static let baseUrlString = "https://finnhub.io/api/v1/"
    static let baseUrlRequest: URLRequest = {
        let url = URL(string: baseUrlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-Finnhub-Token": "c1o6ggq37fkqrr9safcg"]
        return request
    }()

    static let baseLink = URL(string:"https://finnhub.io/api/v1/")
    static let webSocketLink = URL(string: "wss://ws.finnhub.io?token=c1o6ggq37fkqrr9safcg")
    static let headerFields = ["X-Finnhub-Token": "c1o6ggq37fkqrr9safcg"]
}

enum RequestPath: String {
    case news
    case companyNews = "company-news"
    case search
    case companyProfile = "stock/profile2"
    case quote
    case candle = "stock/candle"
}
