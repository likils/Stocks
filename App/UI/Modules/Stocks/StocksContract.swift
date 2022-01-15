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
    var externalSearchResults: [CompanyModel] { get }
    var internalSearchResults: [CompanyModel] { get }
    
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
    var watchlist: [CompanyProfileViewModel] { get }
    
    func updateWatchlist(at index: Int, to newIndex: Int?, with action: Action)
    func requestLogoImage(withSize imageSize: CGFloat, for indexPath: IndexPath) -> ImagePublisher?
    func fetchQuotes(for company: CompanyProfileViewModel, at indexPath: IndexPath)
    func onlineUpdateBegin()
    func onlineUpdateEnd()
    func cellTapped(at index: Int)
    
}

protocol StocksView: AnyObject {
    
    func updateWatchlist(at index: Int, to newIndex: Int?, with action: Action)
    func updateQuotes(_ quotes: CompanyQuotesModel?, at indexPath: IndexPath)
    
}
