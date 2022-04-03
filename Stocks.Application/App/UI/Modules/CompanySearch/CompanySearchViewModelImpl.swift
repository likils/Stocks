// ----------------------------------------------------------------------------
//
//  CompanySearchViewModelImpl.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Resolver
import StocksData
import StocksNetwork
import StocksPersistence

// ----------------------------------------------------------------------------

protocol CompanySearchViewModel: AnyObject {

// MARK: - Methods

//    func searchCompany(with symbol: String)
//    func updateSearchList(at index: Int)
}

// ----------------------------------------------------------------------------

final class CompanySearchViewModelImpl: CompanySearchViewModel {

// MARK: - Private Properties

    private let coordinator: StocksCoordination

    @LazyInjected private var companySearchRequestFactory: CompanySearchRequestFactory

// MARK: - Construction

    init(coordinator: StocksCoordination) {
        self.coordinator = coordinator
    }

// MARK: - Methods

    func searchCompany(with symbol: String) {

        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }

        Task {
            await requestCompanySearch(with: symbol)
        }
    }

    private func requestCompanySearch(with symbol: String) async {
        do {
            let companiesModel = try await companySearchRequestFactory
                .createRequest(searchSymbol: symbol)
                .execute()


        }
        catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        // TODO: Negative scenario
        print("\n\tCompanySearchViewModel Error:", error, "\n")
    }
}
