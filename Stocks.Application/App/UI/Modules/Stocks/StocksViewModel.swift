// ----------------------------------------------------------------------------
//
//  StocksViewModel.swift
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

typealias CompanyProfilesPublisher = AnyPublisher<[CompanyProfileModel], Never>
typealias OnlineTradePublisher = AnyPublisher<OnlineTradeModel, Never>

// ----------------------------------------------------------------------------

protocol StocksViewModel {

    // MARK: - Methods

    func beginOnlineTradeUpdates()

    func endOnlineTradeUpdates()

    func getCompanyProfilesPublisher() -> CompanyProfilesPublisher

    func getImagePublisher(withSize imageSize: Double, for company: CompanyProfileModel) -> ImagePublisher

    func getOnlineTradePublisher(for company: CompanyProfileModel) -> OnlineTradePublisher

    func moveCompany(_ company: CompanyProfileModel, to index: Int)

    func removeCompany(_ company: CompanyProfileModel)

    func showCompanyDetails(for company: CompanyProfileModel)
}

// ----------------------------------------------------------------------------

final class StocksViewModelImpl {

    // MARK: - Private Properties

    private let coordinator: StocksCoordination

    @LazyInjected private var companyProfileRepository: CompanyProfileRepository
    @LazyInjected private var companyQuotesRequestFactory: CompanyQuotesRequestFactory
    @LazyInjected private var imageRequestFactory: ImageRequestFactory
    @LazyInjected private var onlineTradesWebSocketContainer: OnlineTradesWebSocketContainer

    private var onlineTradesWebSocket: OnlineTradesWebSocket {
        get throws {
            try onlineTradesWebSocketContainer.getWebSocket()
        }
    }

    // MARK: - Construction

    init(coordinator: StocksCoordination) {
        self.coordinator = coordinator
    }
    
    // MARK: - Private Methods

    private func createCompanyProfileViewModels(
        with companyProfiles: [CompanyProfileResponseModel]
    ) async -> [CompanyProfileModel] {

        var companyProfileViewModels: [CompanyProfileModel] = .empty

        for companyProfile in companyProfiles {
            do {
                let companyQuotes = try await companyQuotesRequestFactory
                    .createRequest(tickerSymbol: companyProfile.tickerSymbol)
                    .execute()

                let viewModel = CompanyProfileModel(
                    companyProfile: companyProfile,
                    companyQuotes: companyQuotes,
                    inWatchlist: true
                )

                companyProfileViewModels.append(viewModel)
            }
            catch {
                handleError(error)
            }
        }

        return companyProfileViewModels
    }

    private func subscribeToCompanyTrades(with companyTicker: String) {
        do {
            let message = OnlineTradeMessageModel.of(companySymbol: companyTicker, messageType: .subscribe)
            try onlineTradesWebSocket.sendMessage(message)
        }
        catch {
            handleError(error)
        }
    }

    private func unsubscribeFromCompanyTrades(with companyTicker: String) {
        do {
            let message = OnlineTradeMessageModel.of(companySymbol: companyTicker, messageType: .unsubscribe)
            try onlineTradesWebSocket.sendMessage(message)
        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print("\n\tStocksViewModel Error:", error, "\n")
    }
}

// MARK: - @protocol StocksViewModel

extension StocksViewModelImpl: StocksViewModel {

    // MARK: - Methods

    func beginOnlineTradeUpdates() {
        Task {
            let companies = await self.companyProfileRepository.getCompanyProfiles()
            companies.forEach { subscribeToCompanyTrades(with: $0.tickerSymbol) }
        }
    }

    func endOnlineTradeUpdates() {
        Task {
            let companies = await self.companyProfileRepository.getCompanyProfiles()
            companies.forEach { unsubscribeFromCompanyTrades(with: $0.tickerSymbol) }
        }
    }

    func getCompanyProfilesPublisher() -> CompanyProfilesPublisher {

        return self.companyProfileRepository
            .getCompanyProfilesPublisher()
            .asyncFlatMap { [weak self] in
                await self?.createCompanyProfileViewModels(with: $0) ?? .empty
            }
            .eraseToAnyPublisher()
    }

    func getImagePublisher(withSize imageSize: Double, for company: CompanyProfileModel) -> ImagePublisher {

        return Just(())
            .asyncFlatMap { [weak self] in
                return await self?.imageRequestFactory
                    .createRequest(imageLink: company.logoLink, imageSize: imageSize)
                    .prepareImage()
            }
            .eraseToAnyPublisher()
    }

    func getOnlineTradePublisher(for company: CompanyProfileModel) -> OnlineTradePublisher {

        return Just(())
            .tryCompactMap { [weak self] in
                try self?.onlineTradesWebSocket.getPublisher()
            }
            .switchToLatest()
            .compactMap {
                return $0.onlineTrades.last { $0.ticker == company.tickerSymbol }
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

    func moveCompany(_ company: CompanyProfileModel, to index: Int) {
        self.companyProfileRepository.moveCompanyProfile(with: company.tickerSymbol, to: index)
    }

    func removeCompany(_ company: CompanyProfileModel) {
        self.companyProfileRepository.removeCompanyProfile(with: company.tickerSymbol)
    }

    func showCompanyDetails(for company: CompanyProfileModel) {
        self.coordinator.showCompanyDetails(company)
    }
}
