//
//  RequestSettings.swift
//  Stocks
//
//  Created by likils on 10.04.2021.
//

import Foundation

enum RequestSettings {
    
    static let baseUrlString = "https://finnhub.io/api/v1"
    static let baseUrlRequest: URLRequest = {
        let url = URL(string: baseUrlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-Finnhub-Token": "c1o6ggq37fkqrr9safcg"]
        return request
    }()
    
}
