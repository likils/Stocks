// ----------------------------------------------------------------------------
//
//  CompanySearchViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation
import Resolver
import StocksData
import StocksNetwork
import StocksPersistence

// ----------------------------------------------------------------------------

typealias CompanySearchPublisher = AnyPublisher<[CompanySearchModel], Never>

// ----------------------------------------------------------------------------

protocol CompanySearchViewModel: AnyObject {

    // MARK: - Methods

    func viewDidAppear()

    func viewWillDisappear()

    func getCompanySearchPublisher() -> CompanySearchPublisher

    func searchCompany(with symbol: String)

    func showCompanyDetails(for company: CompanySearchModel)
}

// ----------------------------------------------------------------------------

final class CompanySearchViewModelImpl {

    // MARK: - Private Properties

    private let coordinator: StocksCoordination

    private var companyModels: [CompanyModel] = .empty
    private var companiesInWatchList: [CompanyProfileDataModel] = .empty

    private let companySearchPublisher = PassthroughSubject<[CompanySearchModel], Never>()
    private var delayedSearchTimer: Timer?
    private var companyProfilesSubscriber: AnyCancellable?

    @LazyInjected private var companyProfileRequestFactory: CompanyProfileRequestFactory
    @LazyInjected private var companyQuotesRequestFactory: CompanyQuotesRequestFactory
    @LazyInjected private var companySearchRequestFactory: CompanySearchRequestFactory
    @LazyInjected private var companyProfileRepository: CompanyProfileRepository

    // MARK: - Construction

    init(coordinator: StocksCoordination) {
        self.coordinator = coordinator
    }

    // MARK: - Private Methods

    private func updateCompaniesInWatchList(with companiesInWatchlist: [CompanyProfileDataModel]) {
        self.companiesInWatchList = companiesInWatchlist

        if !companyModels.isEmpty {
            updateSearchlist()
        }
    }

    private func updateSearchlist() {

        let companies: [CompanySearchModel] = companyModels.map { company in
            let inWatchList = self.companiesInWatchList.contains(where: { $0.ticker == company.ticker })
            return CompanySearchModel(companyModel: company, inWatchlist: inWatchList)
        }

        self.companySearchPublisher.send(companies)
    }

    private func requestCompanySearch(with symbol: String) async {
        do {
            let companiesModel = try await companySearchRequestFactory
                .createRequest(searchSymbol: symbol)
                .execute()

            self.companyModels = companiesModel.companies.filter { $0.isValid }

            updateSearchlist()
        }
        catch {
            handleError(error)
        }
    }

    private func getCompanyProfileDataModel(with ticker: String) async throws -> CompanyProfileDataModel {
        if let companyProfile = self.companiesInWatchList.first(where: { $0.ticker == ticker }) {
            return companyProfile
        }
        else {
            let responseModel = try await companyProfileRequestFactory
                .createRequest(ticker: ticker)
                .execute()

            return CompanyProfileDataModel(companyProfile: responseModel, inWatchlist: false)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print("\n\tCompanySearchViewModel Error:", error, "\n")
    }
}

// MARK: - @protocol CompanySearchViewModel

extension CompanySearchViewModelImpl: CompanySearchViewModel {

    // MARK: - Methods

    func viewDidAppear() {
        self.companyProfilesSubscriber = self.companyProfileRepository
            .getCompanyProfilesPublisher()
            .sink { [weak self] in self?.updateCompaniesInWatchList(with: $0) }
    }

    func viewWillDisappear() {
        self.companyProfilesSubscriber?.cancel()
        self.delayedSearchTimer?.invalidate()

        self.companyModels = .empty
        updateSearchlist()
    }

    func getCompanySearchPublisher() -> CompanySearchPublisher {
        return self.companySearchPublisher.eraseToAnyPublisher()
    }

    func searchCompany(with symbol: String) {
        self.delayedSearchTimer?.invalidate()

        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }

        self.delayedSearchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            Task { [weak self] in
                await self?.requestCompanySearch(with: text)
            }
        }
    }

    func showCompanyDetails(for company: CompanySearchModel) {
        Task {
            let companyProfileDataModel = try await getCompanyProfileDataModel(with: company.ticker)

            let companyQuotes = try await companyQuotesRequestFactory
                .createRequest(ticker: company.ticker)
                .execute()

            let companyProfile = CompanyProfileModel(
                companyProfileDataModel: companyProfileDataModel,
                companyQuotes: companyQuotes
            )

            DispatchQueue.main.async {
                self.coordinator.showCompanyDetails(companyProfile, data: companyProfileDataModel)
            }
        }
    }
}
