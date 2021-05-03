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
    
}

protocol StocksView: AnyObject {
    
    func showSearchResult(with info: [(Company, CompanyQuotes)])
    
}
