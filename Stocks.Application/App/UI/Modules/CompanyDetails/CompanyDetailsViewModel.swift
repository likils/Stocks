// ----------------------------------------------------------------------------
//
//  CompanyDetailsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation
import Resolver
import StocksData
import StocksNetwork
import StocksPersistence

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

    func getImagePublisher(imageLink: URL, imageSize: Double) -> ImagePublisher

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

    private let coordinator: StocksCoordination
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
        let ticker = self.companyProfileDataModel.ticker

        return Just(())
            .setFailureType(to: Error.self)
            .tryAsyncFlatMap { [weak self] in
                return try await self?.companyQuotesRequestFactory
                    .createRequest(ticker: ticker)
                    .execute()
            }
            .compactMap { companyQuotes in
                return companyQuotes.map { companyQuotes in

                    return CompanyProfileModel(
                        companyProfileDataModel: self.companyProfileDataModel,
                        companyQuotes: companyQuotes
                    )
                }
            }
            .catch { [weak self] error -> Empty in
                self?.handleError(error)
                return Empty()
            }
            .eraseToAnyPublisher()
    }

    func getImagePublisher(imageLink: URL, imageSize: Double) -> ImagePublisher {
        return Just(())
            .asyncFlatMap { [weak self] in
                return await self?.imageRequestFactory
                    .createRequest(imageLink: imageLink, imageSize: imageSize)
                    .prepareImage()
            }
            .eraseToAnyPublisher()
    }

    func getNewsPublisher() -> NewsPublisher {
        let ticker = self.companyProfileDataModel.ticker

        return Just(())
            .setFailureType(to: Error.self)
            .tryAsyncFlatMap { [weak self] in
                return try await self?.companyNewsRequestFactory
                    .createRequest(ticker: ticker, periodInDays: 14)
                    .execute()
            }
            .replaceNil(with: .empty)
            .map { response in
                return response.map { NewsModel(newsResponse: $0) }
            }
            .catch { [weak self] error -> Empty in
                self?.handleError(error)
                return Empty()
            }
            .eraseToAnyPublisher()
    }

    func getOnlineTradePublisher() -> OnlineTradePublisher {
        return Just(())
            .tryCompactMap { [weak self] in
                try self?.onlineTradesWebSocket.getPublisher()
            }
            .switchToLatest()
            .compactMap { [weak self] in
                return $0.onlineTrades.last(
                    where: { $0.ticker == self?.companyProfileDataModel.ticker }
                )
            }
            .collect(.byTime(DispatchQueue.global(), .seconds(2)))
            .compactMap {
                return $0.last
            }
            .catch { [weak self] error -> Empty in
                self?.handleError(error)
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
