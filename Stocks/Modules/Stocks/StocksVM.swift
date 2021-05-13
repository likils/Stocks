//
//  StocksVM.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

class StocksVM: StocksViewModel {
    
    // MARK: - Public properties
    weak var view: StocksView?
    private(set) var externalSearchResults = [Company]()
    private(set) var internalSearchResults = [Company]()
    private(set) var watchlist = [Company]()
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination?
    private let stocksService: StocksService
    
    // MARK: - Init
    init(coordinator: StocksCoordination, stocksService: StocksService) {
        self.coordinator = coordinator
        self.stocksService = stocksService
        
        watchlist = [Company(description: "APPLE INC", displaySymbol: "AAPL", symbol: "AAPL", type: "Common Stock"),
                     Company(description: "TESLA INC", displaySymbol: "TSLA", symbol: "TSLA", type: "Common Stock"),
                     Company(description: "PFIZER INC", displaySymbol: "PFE", symbol: "PFE", type: "Common Stock")]
    }
    
    // MARK: - Public methods
    func searchCompany(with symbol: String) {
        internalSearchResults.removeAll()
        externalSearchResults.removeAll()
        view?.updateSearchlist()
        
        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }
        
        watchlist.forEach {
            if $0.description.lowercased().contains(text) || $0.symbol.lowercased().contains(text) {
                internalSearchResults.append($0)
            }
        }
        
        stocksService.searchCompany(with: text) { [weak self] companies in
            guard let internalSearchResults = self?.internalSearchResults else { return }
            
            let searchResults = Set(companies).subtracting(Set(internalSearchResults))
            self?.externalSearchResults = searchResults.sorted()
            
            DispatchQueue.main.async {
                self?.view?.updateSearchlist()
            }
        }
    }
    
    func updateWatchlist(at index: Int, with action: Action) {
        switch action {
            case .insert:
                let company = externalSearchResults.remove(at: index)
                internalSearchResults.append(company)
                watchlist.append(company)
                view?.updateWatchlist(at: IndexPath(row: watchlist.count-1, section: 0), with: action)
            case .delete:
                watchlist.remove(at: index)
                view?.updateWatchlist(at: IndexPath(row: index, section: 0), with: action)
        }
    }
    
    func fetchQuotes(for company: Company, at indexPath: IndexPath) {
        stocksService.getQuotes(for: company) { quotes in
            guard let quotes = quotes else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateQuotes(quotes, at: indexPath)
            }
        }
    }
    
    func updateQuotes() {
        watchlist.enumerated().forEach { index, company in
            fetchQuotes(for: company, at: IndexPath(row: index, section: 0))
        }
    }
    
}
