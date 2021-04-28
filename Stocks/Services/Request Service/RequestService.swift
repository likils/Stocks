//
//  RequestService.swift
//  Stocks
//
//  Created by likils on 10.04.2021.
//

import Foundation

protocol NewsService: AnyObject {
    
    func getNews(category: News.Category, completion: @escaping ([News]) -> Void)
    
}

protocol CurrencyService: AnyObject {
    
    func getCurrencyRate(currency: String, completion: @escaping (Currency) -> Void)
    
}

class RequestService: NewsService, CurrencyService {
    private enum RequestError: Error, CustomStringConvertible {
        case newsError(error: String)
        case currencyError(error: String)
        
        var description: String {
            switch self {
                case .newsError(let error):
                    return "Received News error: \(error)"
                case .currencyError(let error):
                    return "Received CurrencyRate error: \(error)"
            }
        }
        
    }
    
    // MARK: - Public properties
    
    
    // MARK: - Private properties
    private let session = URLSession.shared
    private let baseUrlString = "https://finnhub.io/api/v1"
    private lazy var baseUrlRequest: URLRequest = {
        let url = URL(string: baseUrlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-Finnhub-Token": "c1o6ggq37fkqrr9safcg"]
        return request
    }()
    
    // MARK: - Public methods
    func getNews(category: News.Category, completion: @escaping ([News]) -> Void) {
        let url = URL(string: baseUrlString + category.urlPart)
        baseUrlRequest.url = url
        
        let task = session.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let news = try JSONDecoder().decode([News].self, from: data)
                    completion(news)
                } catch let error {
                    print("\n::: JSONDecoder News error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received News response:\n\(response)") 
            }
            if let error = error {
                print("\n::: Received News error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getCurrencyRate(currency: String, completion: @escaping (Currency) -> Void) {
        let url = URL(string: baseUrlString + "/forex/rates?base=\(currency)")
        baseUrlRequest.url = url
        
        let task = session.dataTask(with: baseUrlRequest) { data, response, error in
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
    
    // MARK: - Private methods
    
}
