//
//  CompanyDetailsVM.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import Foundation

class CompanyDetailsVM: CompanyDetailsViewModel {
    
    // MARK: - Public properties
    weak var view: CompanyDetailsView?
    private(set) var companyProfile: CompanyProfileViewModel
    private(set) var initTimeline: CandlesTimelineType = .day
    private(set) var news = [NewsModel]()
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let newsService: NewsService
    private let stocksService: StocksService
    private let webSocketService: WebSocketService
    private let cacheService: CacheService
    
    private var tradesTimer: Timer?
    
    // MARK: - Construction
    init(coordinator: StocksCoordination,
         newsService: NewsService,
         stocksService: StocksService,
         webSocketService: WebSocketService,
         cacheService: CacheService,
         companyProfile: CompanyProfileViewModel) {
        
        self.newsService = newsService
        self.coordinator = coordinator
        self.stocksService = stocksService
        self.webSocketService = webSocketService
        self.cacheService = cacheService
        self.companyProfile = companyProfile
    }
    
    // MARK: - Public Methods
    
    // MARK: Company details
    func fetchLogo() {
        let url = companyProfile.logoLink
        
        cacheService.fetchImage(from: url, withSize: 0) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showLogo(image)
            }
        }
    }
    
    func getCandles(withTimeline timeline: CandlesTimelineType) {
        initTimeline = timeline
        stocksService.getCandles(for: companyProfile.ticker, withTimeline: timeline) { candles in
            DispatchQueue.main.async {
                self.view?.updateValues(by: candles, and: timeline)
            }
        }
    }
    
    func updateWatchlist() {

    }
    
    func close() {
        // update watchlist
        coordinator.didFinishClosure?()
    }
    
    func onlineUpdateBegin() {
        webSocketService.initialCompanies = [companyProfile.ticker]
        webSocketService.openConnection()
        webSocketService.receivedData = { [weak self] trades in

            guard let self = self else { return }

            trades.forEach {

                let companyQuotes = self.companyProfile.companyQuotes?.patch(currentPrice: $0.price)
                self.companyProfile = self.companyProfile.copy(with: companyQuotes)
            }
        }
        
        tradesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.view?.updateQuotes()
            }
        }
        tradesTimer?.tolerance = 1
    }
    
    func onlineUpdateEnd() {
        tradesTimer?.invalidate()
        webSocketService.closeConnection()
    }
    
    // MARK: Company news
    func getNews() {
        newsService.getNews(category: .company(ticker: companyProfile.ticker)) { [weak self] news in
            self?.news = news
            
            DispatchQueue.main.async {
                self?.view?.showNews()
            }
        }
    }
    
    func fetchImage(withSize size: Double, for indexPath: IndexPath) {
        guard let url = news[indexPath.row].imageLink else { return }
        
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showImage(image, at: indexPath)
            }
        }
    }
    
    func cellTapped(at index: Int) {
        let url = news[index].sourceLink
        coordinator.showWebPage(with: url)
    }
    
}
