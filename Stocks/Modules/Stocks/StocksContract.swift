//
//  StocksContract.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

// MARK: - Search Module
protocol SearchCompanyViewModel: AnyObject {
    
    var searchView: SearchCompanyView? { get set }
    var externalSearchResults: [Company] { get }
    var internalSearchResults: [Company] { get }
    
    func searchCompany(with symbol: String)
    func updateSearchList(at index: Int)
    
}

protocol SearchCompanyView: AnyObject {
    
    func updateSearchlist()
    
}

// MARK: - Stocks Module

enum Action {
    case insert, delete, move
}

protocol StocksViewModel: AnyObject {
        
    var view: StocksView? { get set }
    var watchlist: [CompanyProfile] { get }
    
    func updateWatchlist(at index: Int, to newIndex: Int?, with action: Action)
    func fetchLogo(from url: URL, withSize size: Double, for indexPath: IndexPath)
    func fetchQuotes(for company: CompanyProfile, at indexPath: IndexPath)
    func onlineUpdateBegin()
    func onlineUpdateEnd()
    
}

protocol StocksView: AnyObject {
    
    func updateWatchlist(at index: Int, to newIndex: Int?, with action: Action)
    func showLogo(_ image: UIImage, at indexPath: IndexPath)
    func updateQuotes(_ quotes: CompanyQuotes?, at indexPath: IndexPath)
    
}
