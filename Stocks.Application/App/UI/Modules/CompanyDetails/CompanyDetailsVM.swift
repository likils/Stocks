//
//  CompanyDetailsVM.swift
//  Stocks
//
//  Created by likils on 25.05.2021.
//

import Combine
import Resolver
import StocksData
import StocksNetwork
import StocksPersistence
import UIKit

class CompanyDetailsVM: CompanyDetailsViewModel {
    
    // MARK: - Properties
    weak var view: CompanyDetailsView?
    private var companyProfileDataModel: CompanyProfileDataModel?
    private(set) var companyProfile: CompanyProfileModel
    private(set) var initTimeline: CompanyCandlesTimeline = .day
    private(set) var news = [NewsModel]()
    
//MARK: - Private Properties

    private let coordinator: StocksCoordination
    
    private var tradesTimer: Timer?

    @LazyInjected private var companyCandlesRequestFactory: CompanyCandlesRequestFactory
    @LazyInjected private var companyNewsRequestFactory: CompanyNewsRequestFactory
    @LazyInjected private var imageRequestFactory: ImageRequestFactory
    @LazyInjected private var companyProfileRepository: CompanyProfileRepository
    
    // MARK: - Construction
    init(coordinator: StocksCoordination,
         companyProfileDataModel: CompanyProfileDataModel? = nil,
         companyProfile: CompanyProfileModel) {
        
        self.coordinator = coordinator
        self.companyProfileDataModel = companyProfileDataModel
        self.companyProfile = companyProfile
    }
    
    // MARK: - Public Methods
    
    // MARK: Company details

    func requestLogoImage() -> ImagePublisher? {
        let logoLink = companyProfile.logoLink
        
        return Future<UIImage?, Never> { promise in

            Task { [unowned self] in
                let image = await self.imageRequestFactory
                    .createRequest(imageLink: logoLink)
                    .prepareImage()
                promise(.success(image))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getCandles(withTimeline timeline: CompanyCandlesTimeline) {
        initTimeline = timeline

        Task {
            await requestCompanyCandles(ticker: companyProfile.ticker, timeline: timeline)
        }
    }
    
    func updateWatchlist() {
        let companyProfile = companyProfileDataModel?.patch(inWatchlist: true)
        self.companyProfileRepository.putCompanyProfile(companyProfile!)
    }
    
    func close() {
        // update watchlist
        coordinator.didFinishClosure?()
    }
    
    func onlineUpdateBegin() {
//        webSocketService.initialCompanies = [companyProfile.ticker]
//        webSocketService.receivedData = { [weak self] trades in
//
//            guard let self = self else { return }
//
//            trades.forEach {
//
//                let companyQuotes = self.companyProfile.companyQuotes?.patch(currentPrice: $0.price)
//                self.companyProfile = self.companyProfile.copy(with: companyQuotes)
//            }
//        }
        
        tradesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.view?.updateQuotes()
            }
        }
        tradesTimer?.tolerance = 1
    }
    
    func onlineUpdateEnd() {
        tradesTimer?.invalidate()
//        webSocketService.closeConnection()
    }
    
    // MARK: Company news
    func getNews() {
        Task {
            await requestNews(ticker: companyProfile.ticker, periodInDays: 10)
        }
    }
    
    func requestNewsImage(withSize imageSize: CGFloat, for indexPath: IndexPath) -> ImagePublisher {

        guard let imageLink = news[indexPath.row].imageLink else {
            return Just(UIImage(named: "ic_news_placeholder")!).eraseToAnyPublisher()
        }

        return Just(())
            .asyncFlatMap { [weak self] in
                return await self?.imageRequestFactory
                    .createRequest(imageLink: imageLink, imageSize: imageSize)
                    .prepareImage()
            }
            .eraseToAnyPublisher()
    }
    
    func cellTapped(at index: Int) {
        let url = news[index].sourceLink
        coordinator.showWebPage(with: url)
    }

    // MARK: - Private Methods

    private func requestNews(ticker: String, periodInDays: Int) async {
        do {
            let newsResponse = try await companyNewsRequestFactory
                .createRequest(ticker: ticker, periodInDays: periodInDays)
                .execute()

            news = newsResponse.map { NewsModel(newsResponse: $0) }

            DispatchQueue.main.async {
                self.view?.showNews()
            }
        }
        catch {
            handleError(error)
        }
    }

    private func requestCompanyCandles(ticker: String, timeline: CompanyCandlesTimeline) async {
        do {
            let companyCandles = try await companyCandlesRequestFactory
                .createRequest(ticker: ticker, timeline: timeline)
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
