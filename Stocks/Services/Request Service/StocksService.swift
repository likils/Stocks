//
//  StocksService.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

protocol StocksService {
    
    func searchCompany(with symbol: String, completion: @escaping ([Company]) -> Void)
    func getQuotes(for company: Company, completion: @escaping (CompanyQuotes?) -> Void)
}

class StocksServiceImpl: StocksService {

    private let baseUrlString = RequestSettings.baseUrlString
    private lazy var baseUrlRequest = RequestSettings.baseUrlRequest
    
    func searchCompany(with symbol: String, completion: @escaping ([Company]) -> Void) {
        let url = URL(string: baseUrlString + "/search?q=\(symbol)")
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
    
    func getQuotes(for company: Company, completion: @escaping (CompanyQuotes?) -> Void) {
        let url = URL(string: baseUrlString + "/quote?symbol=\(company.symbol)")
        baseUrlRequest.url = url
        
        let task = URLSession.shared.dataTask(with: baseUrlRequest) { data, response, error in
            if let data = data {
                let companyQuotes = try? JSONDecoder().decode(CompanyQuotes.self, from: data)
                completion(companyQuotes)
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\n::: Received Quotes response statusCode: \(response.statusCode) for company: \(company.description)(\(company.symbol)).") 
            }
            if let error = error {
                print("\n::: Received Quotes error:\n\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
}
