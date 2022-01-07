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

    static let token = "c1o6ggq37fkqrr9safcg"
    
    static let baseUrlString = "https://finnhub.io/api/v1/"
    static let baseUrlRequest: URLRequest = {
        let url = URL(string: baseUrlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-Finnhub-Token": "c1o6ggq37fkqrr9safcg"]
        return request
    }()
}
