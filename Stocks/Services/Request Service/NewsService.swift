//
//  NewsService.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol NewsService {
    
    func getNews(category: News.Category, completion: @escaping ([News]) -> Void)
    
}

class NewsServiceImpl: NewsService {
    
    private let baseUrlString = RequestSettings.baseUrlString
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func getNews(category: News.Category, completion: @escaping ([News]) -> Void) {
        let url = URL(string: baseUrlString + category.urlPart)
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
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
    
}
