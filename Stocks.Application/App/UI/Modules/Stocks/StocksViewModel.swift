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

    private unowned var coordinator: StocksCoordination

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

    private func createCompanyProfiles(
        with companyProfiles: [CompanyProfileDataModel]
    ) async -> [CompanyProfileModel] {

        var companyProfileViewModels: [CompanyProfileModel] = .empty

        for companyProfile in companyProfiles {
            do {
                let companyQuotes = try await companyQuotesRequestFactory
                    .createRequest(ticker: companyProfile.ticker)
                    .execute()

                let companyProfile = CompanyProfileModel(
                    companyProfileDataModel: companyProfile,
                    companyQuotes: companyQuotes
                )

                companyProfileViewModels.append(companyProfile)
            }
            catch {
                handleError(error)
            }
        }

        return companyProfileViewModels
    }

    private func getImage(_ imageLink: URL, _ imageSize: Double) async -> UIImage? {
        return await self.imageRequestFactory
                .createRequest(imageLink: imageLink, imageSize: imageSize)
                .prepareImage()
    }

    private func updateCompanyTradesSubscription(companyTicker: String, messageType: MessageType) {
        do {
            let message = OnlineTradeMessageModel.of(companyTicker: companyTicker, messageType: messageType)
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
            companies.forEach {
                updateCompanyTradesSubscription(companyTicker: $0.ticker, messageType: .subscribe)
            }
        }
    }

    func endOnlineTradeUpdates() {
        Task {
            let companies = await self.companyProfileRepository.getCompanyProfiles()
            companies.forEach {
                updateCompanyTradesSubscription(companyTicker: $0.ticker, messageType: .unsubscribe)
            }
        }
    }

    func getCompanyProfilesPublisher() -> CompanyProfilesPublisher {
        return self.companyProfileRepository
            .getCompanyProfilesPublisher()
            .asyncFlatMap(createCompanyProfiles)
            .eraseToAnyPublisher()
    }

    func getImagePublisher(withSize imageSize: Double, for company: CompanyProfileModel) -> ImagePublisher {
        return Just((company.logoLink, imageSize))
            .asyncFlatMap(getImage)
            .eraseToAnyPublisher()
    }

    func getOnlineTradePublisher(for company: CompanyProfileModel) -> OnlineTradePublisher {

        return Just(())
            .tryCompactMap {
                try self.onlineTradesWebSocket.getPublisher()
            }
            .switchToLatest()
            .compactMap {
                $0.onlineTrades.last { $0.ticker == company.ticker }
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

    func moveCompany(_ company: CompanyProfileModel, to index: Int) {
        self.companyProfileRepository.moveCompanyProfile(with: company.ticker, to: index)
    }

    func removeCompany(_ company: CompanyProfileModel) {
        self.companyProfileRepository.removeCompanyProfile(with: company.ticker)
    }

    func showCompanyDetails(for company: CompanyProfileModel) {
        Task {
            await companyProfileRepository.getCompanyProfile(with: company.ticker).map { company in

                DispatchQueue.main.async {
                    self.coordinator.showCompanyDetails(with: company)
                }
            }
        }
    }
}
