// ----------------------------------------------------------------------------
//
//  CompanyDetailsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Resolver
import StocksData
import StocksNetwork
import StocksPersistence
import UIKit

// ----------------------------------------------------------------------------

typealias CompanyCandlesPublisher = AnyPublisher<CompanyCandlesModel, Never>
typealias CompanyProfilePublisher = AnyPublisher<CompanyProfileModel, Never>

// ----------------------------------------------------------------------------

protocol CompanyDetailsViewModel: AnyObject {

    // MARK: - Methods

    func beginOnlineTradeUpdates()

    func endOnlineTradeUpdates()

    func getCompanyCandlesPublisher() -> CompanyCandlesPublisher

    func getCompanyCandlesTimeline() -> [CompanyCandlesTimeline]

    func getCompanyProfileDataModel() -> CompanyProfileDataModel

    func getCompanyProfilePublisher() -> CompanyProfilePublisher

    func getImagePublisher(imageLink: URL?, imageSize: Double) -> ImagePublisher

    func getNewsPublisher() -> NewsPublisher

    func getOnlineTradePublisher() -> OnlineTradePublisher

    func pop()

    func showNewsArticle(with newsModel: NewsModel)

    func updateCompanyCandles(with timeline: CompanyCandlesTimeline)

    func updateWatchlist()
}

// ----------------------------------------------------------------------------

final class CompanyDetailsViewModelImpl {

    // MARK: - Private Properties

    private unowned var coordinator: StocksCoordination
    private var companyProfileDataModel: CompanyProfileDataModel

    private let companyCandlesPublisher = PassthroughSubject<CompanyCandlesModel, Never>()

    @LazyInjected private var companyCandlesRequestFactory: CompanyCandlesRequestFactory
    @LazyInjected private var companyNewsRequestFactory: CompanyNewsRequestFactory
    @LazyInjected private var companyQuotesRequestFactory: CompanyQuotesRequestFactory
    @LazyInjected private var imageRequestFactory: ImageRequestFactory
    @LazyInjected private var companyProfileRepository: CompanyProfileRepository
    @LazyInjected private var onlineTradesWebSocketContainer: OnlineTradesWebSocketContainer

    private var onlineTradesWebSocket: OnlineTradesWebSocket {
        get throws {
            try onlineTradesWebSocketContainer.getWebSocket()
        }
    }

    // MARK: - Construction

    init(coordinator: StocksCoordination, companyProfileDataModel: CompanyProfileDataModel) {
        self.coordinator = coordinator
        self.companyProfileDataModel = companyProfileDataModel
    }

    // MARK: - Private Methods

    private func updateCompanyTradesSubscription(messageType: MessageType) {
        do {
            let message = OnlineTradeMessageModel.of(companyTicker: companyProfileDataModel.ticker, messageType: messageType)
            try onlineTradesWebSocket.sendMessage(message)
        }
        catch {
            handleError(error)
        }
    }

    private func requestImage(_ imageLink: URL?, _ imageSize: Double) async -> UIImage? {
        var image = UIImage(named: "ic_news_placeholder")

        if let imageLink = imageLink {
            image = await self.imageRequestFactory
                .createRequest(imageLink: imageLink, imageSize: imageSize)
                .prepareImage()
        }

        return image
    }

    private func requestCompanyQuotes(_ ticker: String) async throws -> CompanyQuotesModel {
        return try await self.companyQuotesRequestFactory
            .createRequest(ticker: ticker)
            .execute()
    }

    private func requestCompanyNews(_ ticker: String, periodInDays: Int) async throws -> [NewsResponseModel] {
        return try await self.companyNewsRequestFactory
            .createRequest(ticker: ticker, periodInDays: periodInDays)
            .execute()
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print(error)
    }
}

// MARK: - @protocol CompanyDetailsViewModel

extension CompanyDetailsViewModelImpl: CompanyDetailsViewModel {

    // MARK: - Methods

    func beginOnlineTradeUpdates() {
        updateCompanyTradesSubscription(messageType: .subscribe)
    }

    func endOnlineTradeUpdates() {
        updateCompanyTradesSubscription(messageType: .unsubscribe)
    }

    func getCompanyCandlesPublisher() -> CompanyCandlesPublisher {
        return self.companyCandlesPublisher.eraseToAnyPublisher()
    }

    func getCompanyCandlesTimeline() -> [CompanyCandlesTimeline] {
        return CompanyCandlesTimeline.allCases
    }

    func getCompanyProfileDataModel() -> CompanyProfileDataModel {
        return self.companyProfileDataModel
    }

    func getCompanyProfilePublisher() -> CompanyProfilePublisher {

        return Just(self.companyProfileDataModel.ticker)
            .setFailureType(to: Error.self)
            .tryAsyncFlatMap(requestCompanyQuotes)
            .map {
                CompanyProfileModel(
                    companyProfileDataModel: self.companyProfileDataModel,
                    companyQuotes: $0
                )
            }
            .catch { error -> Empty in
                self.handleError(error)
                return Empty()
            }
            .eraseToAnyPublisher()
    }

    func getImagePublisher(imageLink: URL?, imageSize: Double) -> ImagePublisher {
        return Just((imageLink, imageSize))
            .asyncFlatMap(requestImage)
            .eraseToAnyPublisher()
    }

    func getNewsPublisher() -> NewsPublisher {

        return Just((self.companyProfileDataModel.ticker, 14))
            .setFailureType(to: Error.self)
            .tryAsyncFlatMap(requestCompanyNews)
            .map {
                $0.map { NewsModel(newsResponse: $0) }
            }
            .catch { error -> Empty in
                self.handleError(error)
                return Empty()
            }
            .eraseToAnyPublisher()
    }

    func getOnlineTradePublisher() -> OnlineTradePublisher {
        return Just(())
            .tryCompactMap {
                try self.onlineTradesWebSocket.getPublisher()
            }
            .switchToLatest()
            .compactMap {
                $0.onlineTrades.last {
                    $0.ticker == self.companyProfileDataModel.ticker
                }
            }
            .collect(.byTime(DispatchQueue.global(), .seconds(2)))
            .compactMap {
                $0.last
            }
            .catch { error -> Empty in
                self.handleError(error)
                return Empty(completeImmediately: false)
            }
            .eraseToAnyPublisher()
    }

    func pop() {
        self.coordinator.didFinishClosure?()
    }

    func showNewsArticle(with newsModel: NewsModel) {
        self.coordinator.showWebPage(with: newsModel.sourceLink)
    }

    func updateCompanyCandles(with timeline: CompanyCandlesTimeline) {
        Task {
            let candles = try await self.companyCandlesRequestFactory
                .createRequest(ticker: self.companyProfileDataModel.ticker, timeline: timeline)
                .execute()

            self.companyCandlesPublisher.send(candles)
        }
    }

    func updateWatchlist() {
        self.companyProfileDataModel = self.companyProfileDataModel
            .patch(
                inWatchlist: !self.companyProfileDataModel.inWatchlist
            )

        self.companyProfileDataModel.inWatchlist
            ? companyProfileRepository.putCompanyProfile(self.companyProfileDataModel)
            : companyProfileRepository.removeCompanyProfile(with: self.companyProfileDataModel.ticker)
    }
}
