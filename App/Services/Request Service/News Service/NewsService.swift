//
//  NewsService.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol NewsService {
    
    func getNews(category: LegacyNewsType, completion: @escaping ([NewsModel]) -> Void)
    
}

class NewsServiceImpl: NewsService {
    
    func getNews(category: LegacyNewsType, completion: @escaping ([NewsModel]) -> Void) {

        let baseLink = RequestSettings.baseLink
        let path: RequestPath
        let headerFields = RequestSettings.headerFields

        let jsonEncoder = JSONEncoder()
        let queryParams: Data?

        if case .company(let companySymbol) = category {
            let fromDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
            let requestModel = CompanyNewsRequestModel(companySymbol: companySymbol, fromDate: fromDate, toDate: Date())
            path = .companyNews
            queryParams = try? jsonEncoder.encode(requestModel)
        }
        else {
            let requestModel = NewsRequestModel(category: category.newsType)
            path = .news
            queryParams = try? jsonEncoder.encode(requestModel)
        }

        let urlRequest = try! UrlRequestFactory.create(baseLink, path: path, headerFields: headerFields, queryParams: queryParams)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let news = try JSONDecoder().decode([NewsModel].self, from: data)
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

fileprivate extension LegacyNewsType {

    var urlPath: String {
        switch self {
            case .company:
                return "company-news"
            default:
                return "news"
        }
    }

    var newsType: NewsType {
        switch self {
            case .company:
                return .general
            case .crypto:
                return .crypto
            case .forex:
                return .forex
            case .general:
                return .general
            case .merger:
                return .merger
        }
    }
}
