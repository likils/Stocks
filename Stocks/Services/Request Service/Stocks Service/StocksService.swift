//
//  StocksService.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

protocol StocksService {
    
    func searchCompany(with symbol: String, completion: @escaping ([Company]) -> Void)
    func getCompanyProfile(for company: Company, completion: @escaping (CompanyProfile) -> Void)
    func getQuotes(for company: CompanyProfile, completion: @escaping (CompanyQuotes?) -> Void)
    func getCandles(for company: CompanyProfile, withTimeline timeline: CompanyCandles.TimeLine, completion: @escaping (CompanyCandles) -> Void)
    
}

class StocksServiceImpl: StocksService {

    private var baseUrlString: String {
        RequestSettings.baseUrlString
    }
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func searchCompany(with symbol: String, completion: @escaping ([Company]) -> Void) {
        let query = ["q": symbol]
        let url = URL(string: baseUrlString + "/search?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let companies = try JSONDecoder().decode(SearchedCompanies.self, from: data)
                    completion(companies.result)
                } catch let error {
                    print("\n::: JSONDecoder Company error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Company response:\n\(response)") 
            }
            if let error = error {
                print("\n::: Received Company error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getCompanyProfile(for company: Company, completion: @escaping (CompanyProfile) -> Void) {
        let query = ["symbol": company.symbol]
        let url = URL(string: baseUrlString + "/stock/profile2?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let profile = try JSONDecoder().decode(CompanyProfile.self, from: data)
                    completion(profile)
                } catch let error {
                    print("\n::: JSONDecoder CompanyProfile error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received CompanyProfile response statusCode: \(response.statusCode) for company: \(company.description)(\(company.symbol)).\n\(response.description)") 
            }
            if let error = error {
                print("\n::: Received CompanyProfile error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    func getQuotes(for company: CompanyProfile, completion: @escaping (CompanyQuotes?) -> Void) {
        let query = ["symbol": company.ticker]
        let url = URL(string: baseUrlString + "/quote?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                let companyQuotes = try? JSONDecoder().decode(CompanyQuotes.self, from: data)
                completion(companyQuotes)
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Quotes response statusCode: \(response.statusCode) for company: \(company.name)(\(company.ticker)).\n\(response.description)") 
            }
            if let error = error {
                print("\n::: Received Quotes error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getCandles(for company: CompanyProfile, withTimeline timeline: CompanyCandles.TimeLine, completion: @escaping (CompanyCandles) -> Void) {
        let query = ["symbol": company.ticker].merging(timeline.query) { current, _ in current }
        let url = URL(string: baseUrlString + "/stock/candle?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let candles = try JSONDecoder().decode(CompanyCandles.self, from: data)
                    completion(candles)
                } catch let error {
                    print("\n::: JSONDecoder CompanyCandles error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Candles response statusCode: \(response.statusCode) for company: \(company.name)(\(company.ticker)).\n\(response.description)") 
            }
            if let error = error {
                print("\n::: Received Candles error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
