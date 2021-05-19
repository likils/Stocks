//
//  StocksVM.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

class StocksVM: StocksViewModel, SearchCompanyViewModel {
    
    // MARK: - Public properties
    weak var searchView: SearchCompanyView?
    private(set) var externalSearchResults = [Company]()
    private(set) var internalSearchResults = [Company]()
    
    weak var view: StocksView?
    private(set) var watchlist = [CompanyProfile]() { didSet { save() } }
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination?
    private let stocksService: StocksService
    private let cacheService: CacheService
    
    // MARK: - Init
    init(coordinator: StocksCoordination, stocksService: StocksService, cacheService: CacheService) {
        self.coordinator = coordinator
        self.stocksService = stocksService
        self.cacheService = cacheService
        
        load()
    }
    
    // MARK: - Public methods
    func searchCompany(with symbol: String) {
        internalSearchResults.removeAll()
        externalSearchResults.removeAll()
        searchView?.updateSearchlist()
        
        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }
        
        watchlist.forEach {
            if $0.name.lowercased().contains(text) || $0.ticker.lowercased().contains(text) {
                internalSearchResults.append(Company(description: $0.name, symbol: $0.ticker))
            }
        }
        
        stocksService.searchCompany(with: text) { [weak self] companies in
            guard let internalSearchResults = self?.internalSearchResults.map({$0.symbol}) else { return }
            let result = Set(internalSearchResults)
            
            self?.externalSearchResults = companies.filter { !$0.symbol.contains(".") && !result.contains($0.symbol) }
            
            DispatchQueue.main.async {
                self?.searchView?.updateSearchlist()
            }
        }
    }
    
    func updateSearchList(at index: Int) {
        updateWatchlist(at: index, to: nil, with: .insert)
    }
    
    func updateWatchlist(at index: Int, to newIndex: Int?, with action: Action) {
        switch action {
            case .insert:
                let company = externalSearchResults.remove(at: index)
                internalSearchResults.append(company)
                
                stocksService.getCompanyProfile(for: company) { [weak self] profile in
                    if let self = self {
                        self.watchlist.append(profile)
                        
                        DispatchQueue.main.async {
                            self.view?.updateWatchlist(at: IndexPath(row: self.watchlist.count-1, section: 0), with: action)
                        }
                    }
                }
            case .delete:
                watchlist.remove(at: index)
                view?.updateWatchlist(at: IndexPath(row: index, section: 0), with: action)
            case .move:
                guard let newIndex = newIndex else { return }
                let company = watchlist.remove(at: index)
                watchlist.insert(company, at: newIndex)
        }
    }
    
    func fetchLogo(from url: URL, withSize size: Float, for indexPath: IndexPath) {
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showLogo(image, at: indexPath)
            }
        }
    }
    
    func fetchQuotes(for company: CompanyProfile, at indexPath: IndexPath) {
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
    
    // MARK: - Saving for app tests
    
    private var url: URL {
        try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("watchlist.json")
    }
    private func save() {
        if let data = try? JSONEncoder().encode(watchlist) {
            try? data.write(to: url)
        }
    }
    
    private func load() {
        if let data = try? Data(contentsOf: url), 
           let watchlist = try? JSONDecoder().decode([CompanyProfile].self, from: data) {
            self.watchlist = watchlist
        }
    }
    
}
