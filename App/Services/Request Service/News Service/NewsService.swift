//
//  NewsService.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import Foundation

protocol NewsService {
    
    func getNews(category: NewsType, completion: @escaping ([NewsModel]) -> Void)
    
}

class NewsServiceImpl: NewsService {
    
    private var baseUrlString: String {
        RequestSettings.baseUrlString
    }
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func getNews(category: NewsType, completion: @escaping ([NewsModel]) -> Void) {
        let url = URL(string: baseUrlString + category.urlPath)?.withQueries(category.query)

        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
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

fileprivate extension NewsType {

    var urlPath: String {
        switch self {
            case .company:
                return "/company-news?"
            default:
                return "/news?"
        }
    }

    var query: [String: String] {
        switch self {
            case .general:
                return ["category": "general"]
            case .forex:
                return ["category": "forex"]
            case .crypto:
                return ["category": "crypto"]
            case .merger:
                return ["category": "merger"]
            case .company(let ticker):
                let pastDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                let past = formatter.string(from: pastDate)
                let present = formatter.string(from: Date())

                return ["symbol": ticker, "from": past, "to": present]
        }
    }
}
/*
{
    \"category\":\"company\",
    \"datetime\":1635408000,
    \"headline\":\"3 Stock Market Charts to Make You an Investing Genius\",
    \"id\":71800592,
    \"image\":\"https://www.nasdaq.com/sites/acquia.prod/files/2019-05/0902-Q19%20Total%20Markets%20photos%20and%20gif_CC8.jpg?1687661269\",
    \"related\":\"AAPL\",
    \"source\":\"Nasdaq\",
    \"summary\":\"Having the right information and how to interpret it can totally change your investing strategy and lead you to big returns in the stock market. Unfortunately, there\'s an overwhelming amount of information out there about companies, and it\'s not always obvious to the retail inve\",
    \"url\":\"https://finnhub.io/api/news?id=2728bb4a122ab28758377fd39dc879f769d7f5c5f95194c2bfb4041891554c49\"
}

{
    \"category\":\"top news\",
    \"datetime\":1636142180,
    \"headline\":\"Stocks could soar to new heights in week ahead — even though inflation data may come in hot\",
    \"id\":6990712,
    \"image\":\"https://image.cnbcfm.com/api/v1/image/106950566-1633035876431-wall.jpg?v=1636140909\",
    \"related\":\"\",
    \"source\":\"CNBC\",
    \"summary\":\"Stocks could take aim at new highs, even as investors face data that could show the highest year-over-year jump in consumer prices since 1990.\",
    \"url\":\"https://www.cnbc.com/2021/11/05/stocks-could-soar-to-new-heights-in-week-ahead-even-though-inflation-data-may-come-in-hot.html\"
}
*/
