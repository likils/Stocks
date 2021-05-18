//
//  CurrencyService.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol CurrencyService {
    
    func getCurrencyRate(currency: String, completion: @escaping (Currency) -> Void)
    
}

class CurrencyServiceImpl: CurrencyService {
    
    private var baseUrlString: String {
        RequestSettings.baseUrlString
    }
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func getCurrencyRate(currency: String, completion: @escaping (Currency) -> Void) {
        let query = ["base": currency]
        let url = URL(string: baseUrlString + "/forex/rates?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    completion(currency)
                } catch let error {
                    print("\n::: JSONDecoder CurrencyRate error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received CurrencyRate response:\n\(response)") 
            }
            if let error = error {
                print("\n::: Received CurrencyRate error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
