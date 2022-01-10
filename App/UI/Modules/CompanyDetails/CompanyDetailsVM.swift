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
    private(set) var initTimeline: CompanyCandlesTimeline = .day
    private(set) var news = [NewsModel]()
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let webSocketService: WebSocketService
    private let cacheService: CacheService
    
    private var tradesTimer: Timer?
    
    // MARK: - Construction
    init(coordinator: StocksCoordination,
         webSocketService: WebSocketService,
         cacheService: CacheService,
         companyProfile: CompanyProfileViewModel) {
        
        self.coordinator = coordinator
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
    
    func getCandles(withTimeline timeline: CompanyCandlesTimeline) {
        initTimeline = timeline

        Task {
            await requestCompanyCandles(tickerSymbol: companyProfile.tickerSymbol, timeline: timeline)
        }
    }
    
    func updateWatchlist() {

    }
    
    func close() {
        // update watchlist
        coordinator.didFinishClosure?()
    }
    
    func onlineUpdateBegin() {
        webSocketService.initialCompanies = [companyProfile.tickerSymbol]
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
        Task {
            await requestNews(tickerSymbol: companyProfile.tickerSymbol, periodInDays: 10)
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

    // MARK: - Private Methods

    private func requestNews(tickerSymbol: String, periodInDays: Int) async {
        do {
            news = try await NewsRequestFactory
                .createRequest(tickerSymbol: tickerSymbol, periodInDays: periodInDays)
                .execute()

            DispatchQueue.main.async {
                self.view?.showNews()
            }
        }
        catch {
            handleError(error)
        }
    }

    private func requestCompanyCandles(tickerSymbol: String, timeline: CompanyCandlesTimeline) async {
        do {
            let companyCandles = try await CompanyCandlesRequestFactory
                .createRequest(tickerSymbol: tickerSymbol, timeline: timeline)
                .execute()

            DispatchQueue.main.async {
                self.view?.updateValues(by: companyCandles, and: timeline)
            }
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print(error)
    }
}
