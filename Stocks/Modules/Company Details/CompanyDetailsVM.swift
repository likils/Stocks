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
    private(set) var companyProfile: CompanyProfile
    private(set) var news = [News]()
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let newsService: NewsService
    private let stocksService: StocksService
    private let webSocketService: WebSocketService
    private let cacheService: CacheService
    
    private var tradesTimer: Timer?
    
    // MARK: - Init
    init(coordinator: StocksCoordination,
         newsService: NewsService,
         stocksService: StocksService,
         webSocketService: WebSocketService,
         cacheService: CacheService,
         companyProfile: CompanyProfile) {
        
        self.newsService = newsService
        self.coordinator = coordinator
        self.stocksService = stocksService
        self.webSocketService = webSocketService
        self.cacheService = cacheService
        self.companyProfile = companyProfile
    }
    
    // MARK: - Public methods
    
    // MARK: Company details
    func getCandles(withTimeline timeline: CompanyCandles.TimeLine) {
        stocksService.getCandles(for: companyProfile, withTimeline: timeline) { candles in
            print(candles.openPrices.count)
            print(candles.closePrices.count)
            print(candles.highPrices.count)
            print(candles.lowPrices.count)
            print(candles.timestamps.count)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.timeZone = .current
            
            let fromDate = Date(timeIntervalSince1970: candles.timestamps.first!)
            let toDate = Date(timeIntervalSince1970: candles.timestamps.last!)
            print(formatter.string(from: fromDate))
            print(formatter.string(from: toDate))
        }
    }
    
    func fetchLogo() {
        guard let url = companyProfile.logoUrl else { return }
        
        cacheService.fetchImage(from: url, withSize: 0) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showLogo(image)
            }
        }
    }
    
    func onlineUpdateBegin() {
        webSocketService.initialCompanies = [companyProfile]
        webSocketService.openConnection()
        webSocketService.receivedData = { [weak self] trades in
            trades.forEach {
                self?.companyProfile.companyQuotes?.currentPrice = $0.price
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
        newsService.getNews(category: .company(companyProfile)) { [weak self] news in
            self?.news = news
            
            DispatchQueue.main.async {
                self?.view?.showNews()
            }
        }
    }
    
    func fetchImage(withSize size: Double, for indexPath: IndexPath) {
        guard let url = news[indexPath.row].imageUrl else { return }
        
        cacheService.fetchImage(from: url, withSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.view?.showImage(image, at: indexPath)
            }
        }
    }
    
    func cellTapped(at index: Int) {
        let url = news[index].sourceUrl
        coordinator.showWebPage(with: url)
    }
    
    // MARK: - Private methods
    
    
}
