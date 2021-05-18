//
//  StocksContract.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

enum Action {
    case insert, delete
}

protocol StocksViewModel: AnyObject {
        
    var view: StocksView? { get set }
    var externalSearchResults: [Company] { get }
    var internalSearchResults: [Company] { get }
    var watchlist: [CompanyProfile] { get }
    
    func searchCompany(with symbol: String)
    func updateWatchlist(at index: Int, with action: Action)
    func fetchLogo(from url: URL, withSize size: Float, for indexPath: IndexPath)
    func fetchQuotes(for company: CompanyProfile, at indexPath: IndexPath)
    func updateQuotes()
    
}

protocol StocksView: AnyObject {
    
    func updateSearchlist()
    func updateWatchlist(at indexPath: IndexPath, with action: Action)
    func showLogo(_ image: UIImage, at indexPath: IndexPath)
    func updateQuotes(_ quotes: CompanyQuotes, at indexPath: IndexPath)
    
}
