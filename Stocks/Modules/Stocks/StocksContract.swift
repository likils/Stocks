//
//  StocksContract.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

protocol StocksViewModel: AnyObject {
        
    var view: StocksView? { get set }
    
    func searchCompany(_ name: String)
    func fetchQuotes(for company: Company)
    func reloadQuotes(for companies: [Company])
    
}

protocol StocksView: AnyObject {
    
    func show(companies: [Company])
    func add(company: (Company, CompanyQuotes))
    
}
