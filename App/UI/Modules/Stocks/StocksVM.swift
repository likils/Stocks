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
    private(set) var externalSearchResults = [CompanyModel]()
    private(set) var internalSearchResults = [CompanyModel]()
    
    weak var view: StocksView?
    private(set) var watchlist = [CompanyProfileViewModel]() { didSet { save() } }
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let stocksService: StocksService
    private let webSocketService: WebSocketService
    private let cacheService: CacheService
    
    private var companyIndexInWatchlist = [String: Int]()
    private var tradesTimer: Timer?
    
    // MARK: - Construction
    init(coordinator: StocksCoordination,
         stocksService: StocksService,
         webSocketService: WebSocketService,
         cacheService: CacheService) {
        
        self.coordinator = coordinator
        self.stocksService = stocksService
        self.webSocketService = webSocketService
        self.cacheService = cacheService
        
        load()
    }
    
    // MARK: - Public Methods
    
    // MARK: SearchCompanyViewModel
    func searchCompany(with symbol: String) {
        internalSearchResults.removeAll()
        externalSearchResults.removeAll()
        searchView?.updateSearchlist()
        
        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }
        
        watchlist.forEach {
            if $0.name.lowercased().contains(text) || $0.ticker.lowercased().contains(text) {
                internalSearchResults.append(CompanyModel(name: $0.name, ticker: $0.ticker))
            }
        }
        
        stocksService.searchCompany(with: text) { [weak self] companies in
            guard let internalSearchResults = self?.internalSearchResults.map({$0.ticker}) else { return }
            let result = Set(internalSearchResults)
            
            self?.externalSearchResults = companies.filter { !$0.ticker.contains(".") && !result.contains($0.ticker) }
            
            DispatchQueue.main.async {
                self?.searchView?.updateSearchlist()
            }
        }
    }
    
    func updateSearchList(at index: Int) {
        updateWatchlist(at: index, with: .insert)
    }
    
    // MARK: StocksViewModel
    func updateWatchlist(at index: Int, to newIndex: Int? = nil, with action: Action) {
        switch action {
            case .insert:
                let company = externalSearchResults.remove(at: index)
                internalSearchResults.append(company)
                
                stocksService.getCompanyProfile(for: company.ticker) { [weak self] profile in
                    if let self = self {
                        
                        let profile = CompanyProfileViewModel(companyProfile: profile, inWatchlist: true)
                        
                        self.watchlist.append(profile)
                        self.companyIndexInWatchlist[profile.ticker] = self.watchlist.count-1
                        
                        DispatchQueue.main.async {
                            self.view?.updateWatchlist(at: self.watchlist.count - 1, to: nil, with: action)
                        }
                        
                        self.webSocketService.subscribeTo(companyTicker: profile.ticker)
                    }
                }

            case .delete:
                let profile = watchlist.remove(at: index)
                webSocketService.unsubscribeFrom(companyTicker: profile.ticker)
                companyIndexInWatchlist.removeAll()
                
                watchlist.enumerated().forEach { index, profile in
                    companyIndexInWatchlist[profile.ticker] = index
                }
                view?.updateWatchlist(at: index, to: nil, with: action)
                
            case .move:
                guard let newIndex = newIndex else { return }
                let profile = watchlist.remove(at: index)
                watchlist.insert(profile, at: newIndex)
                
                watchlist.enumerated().forEach { index, profile in
                    companyIndexInWatchlist[profile.ticker] = index
                }
                view?.updateWatchlist(at: index, to: newIndex, with: action)
        }
    }
    
    func fetchLogo(withSize size: Double, for indexPath: IndexPath) {
        let url = watchlist[indexPath.row].logoLink
        
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showLogo(image, at: indexPath)
            }
        }
    }
    
    func fetchQuotes(for company: CompanyProfileViewModel, at indexPath: IndexPath) {
        stocksService.getQuotes(for: company.ticker) { quotes in
            guard let quotes = quotes else { return }
            
            DispatchQueue.main.async { [self] in
                self.view?.updateQuotes(quotes, at: indexPath)

                self.watchlist[indexPath.row] = self.watchlist[indexPath.row].copy(with: quotes)
            }
        }
    }
    
    func onlineUpdateBegin() {
        webSocketService.initialCompanies = watchlist.map { $0.ticker }
        webSocketService.openConnection()
        webSocketService.receivedData = { [weak self] trades in
            trades.forEach {
                if let self = self,
                   let index = self.companyIndexInWatchlist[$0.ticker] {

                    let companyQuotes = self.watchlist[index].companyQuotes?.patch(currentPrice: $0.price)
                    self.watchlist[index] = self.watchlist[index].copy(with: companyQuotes)
                }
            }
        }
        
        tradesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateQuotes()
            }
        }
        tradesTimer?.tolerance = 1
    }
    
    func onlineUpdateEnd() {
        tradesTimer?.invalidate()
        webSocketService.closeConnection()
    }
    
    func cellTapped(at index: Int) {
        let company = watchlist[index]
        coordinator.showCompanyDetails(company)
    }
    
    // MARK: - Private Methods
    private func updateQuotes() {
        watchlist.enumerated().forEach { index, company in
            view?.updateQuotes(company.companyQuotes, at: IndexPath(row: index, section: 0))
        }
    }
    
    // MARK: - Saving for app tests
    
    private var url: URL? {
        try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("watchlist.json")
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(watchlist), let url = url {
            try? data.write(to: url)
        }
    }
    
    private func load() {
        if let url = url,
           let data = try? Data(contentsOf: url), 
           let watchlist = try? JSONDecoder().decode([CompanyProfileViewModel].self, from: data) {
            
            self.watchlist = watchlist
            watchlist.enumerated().forEach { index, company in
                companyIndexInWatchlist[company.ticker] = index
            }
        }
    }
    
}
