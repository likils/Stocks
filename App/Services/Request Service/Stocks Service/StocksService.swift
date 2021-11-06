//
//  StocksService.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

protocol StocksService {
    
    func searchCompany(with symbol: String, completion: @escaping ([CompanyModel]) -> Void)
    func getCompanyProfile(for companyTicker: String, completion: @escaping (CompanyProfileModel) -> Void)
    func getQuotes(for companyTicker: String, completion: @escaping (CompanyQuotesModel?) -> Void)
    func getCandles(for companyTicker: String, withTimeline timeline: CandlesTimelineType, completion: @escaping (CandlesModel) -> Void)
    
}

class StocksServiceImpl: StocksService {

    private var baseUrlString: String {
        RequestSettings.baseUrlString
    }
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func searchCompany(with symbol: String, completion: @escaping ([CompanyModel]) -> Void) {
        let query = ["q": symbol]
        let url = URL(string: baseUrlString + "/search?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let companies = try JSONDecoder().decode(CompaniesModel.self, from: data)
                    completion(companies.companies)
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
    
    func getCompanyProfile(for companyTicker: String, completion: @escaping (CompanyProfileModel) -> Void) {
        let query = ["symbol": companyTicker]
        let url = URL(string: baseUrlString + "/stock/profile2?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let profile = try JSONDecoder().decode(CompanyProfileModel.self, from: data)
                    completion(profile)
                } catch let error {
                    print("\n::: JSONDecoder CompanyProfile error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received CompanyProfile response statusCode: \(response.statusCode) for company: \(companyTicker).\n\(response.description)")
            }
            if let error = error {
                print("\n::: Received CompanyProfile error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    func getQuotes(for companyTicker: String, completion: @escaping (CompanyQuotesModel?) -> Void) {
        let query = ["symbol": companyTicker]
        let url = URL(string: baseUrlString + "/quote?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                let companyQuotes = try? JSONDecoder().decode(CompanyQuotesModel.self, from: data)
                completion(companyQuotes)
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Quotes response statusCode: \(response.statusCode) for company: \(companyTicker).\n\(response.description)")
            }
            if let error = error {
                print("\n::: Received Quotes error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getCandles(for companyTicker: String, withTimeline timeline: CandlesTimelineType, completion: @escaping (CandlesModel) -> Void) {
        let query = ["symbol": companyTicker].merging(timeline.query) { current, _ in current }
        let url = URL(string: baseUrlString + "/stock/candle?")?.withQueries(query)
        
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                do {
                    let candles = try JSONDecoder().decode(CandlesModel.self, from: data)
                    completion(candles)
                } catch let error {
                    print("\n::: JSONDecoder CompanyCandles error:\n\(error.localizedDescription)")
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Candles response statusCode: \(response.statusCode) for company: \(companyTicker).\n\(response.description)")
            }
            if let error = error {
                print("\n::: Received Candles error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}
// ----------------------------------------------------------------------------

fileprivate extension CandlesTimelineType {

// MARK: - Properties

    var query: [String: String] {

        let pastDate: Date
        let resolution: Resolution

        switch self {
            case .day:
                resolution = .minute
                pastDate = Calendar.current.startOfDay(for: Date())
            case .week:
                resolution = .minutes_15
                pastDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            case .month:
                resolution = .minutes_60
                pastDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            case .year:
                resolution = .day
                pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            case .all:
                resolution = .month
                pastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        }

        // convert to UNIX timestamp
        let past = Int(pastDate.timeIntervalSince1970)
        let current = Int(Date().timeIntervalSince1970)

        return ["resolution": resolution.rawValue,
                "from": String(past),
                "to": String(current)]
    }

    private enum Resolution: String {
        case minute = "1"
        case minutes_5 = "5"
        case minutes_15 = "15"
        case minutes_30 = "30"
        case minutes_60 = "60"
        case day = "D"
        case week = "W"
        case month = "M"
    }
}
