//
//  StocksVM.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Combine
import UIKit

class StocksVM: StocksViewModel, SearchCompanyViewModel {
    
    // MARK: - Public properties
    weak var searchView: SearchCompanyView?
    private(set) var externalSearchResults = [CompanyModel]()
    private(set) var internalSearchResults = [CompanyModel]()
    
    weak var view: StocksView?
    private(set) var watchlist = [CompanyProfileViewModel]()
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let webSocketService: WebSocketService
    
    private var companyIndexInWatchlist = [String: Int]()
    private var tradesTimer: Timer?

    private let companyProfileRepository: CompanyProfileRepository = {
        let storage = DocumentDirectoryStorage<String, [CompanyProfileModel]>(documentName: "\(CompanyProfileRepository.self)")
        let repository = CompanyProfileRepositoryImpl(storage: storage.eraseToAnyStorage())
        return repository
    }()

    private var companyProfilesSubscriber: AnyCancellable?
    
    // MARK: - Construction
    init(coordinator: StocksCoordination, webSocketService: WebSocketService) {
        self.coordinator = coordinator
        self.webSocketService = webSocketService
        
        subscribeToCompanyProfileChanges()
    }
    
    // MARK: - Public Methods
    
    // MARK: SearchCompanyViewModel
    func searchCompany(with symbol: String) {
        internalSearchResults.removeAll()
        externalSearchResults.removeAll()
        searchView?.updateSearchlist()
        
        let text = symbol.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.isEmpty else { return }
        
        watchlist.forEach {
            if $0.name.lowercased().contains(text) || $0.tickerSymbol.lowercased().contains(text) {
                internalSearchResults.append(CompanyModel(name: $0.name, ticker: $0.tickerSymbol))
            }
        }

        Task {
            await requestCompanySearch(with: symbol)
        }
    }
    
    func updateSearchList(at index: Int) {
        updateWatchlist(at: index, with: .insert)
    }
    
    // MARK: StocksViewModel
    func updateWatchlist(at index: Int, to newIndex: Int? = nil, with action: Action) {
        switch action {
            case .insert:
                let company = externalSearchResults.remove(at: index)
                internalSearchResults.append(company)

                Task {
                    await requestCompanyProfile(with: company.ticker)
                }

            case .delete:
                let profile = watchlist.remove(at: index)
                webSocketService.unsubscribeFrom(companyTicker: profile.tickerSymbol)
                companyIndexInWatchlist.removeAll()
                
                watchlist.enumerated().forEach { index, profile in
                    companyIndexInWatchlist[profile.tickerSymbol] = index
                }
                view?.updateWatchlist(at: index, to: nil, with: action)

                companyProfileRepository.removeCompanyProfile(atIndex: index)
                
            case .move:
                guard let newIndex = newIndex else { return }
                let profile = watchlist.remove(at: index)
                watchlist.insert(profile, at: newIndex)
                
                watchlist.enumerated().forEach { index, profile in
                    companyIndexInWatchlist[profile.tickerSymbol] = index
                }
                view?.updateWatchlist(at: index, to: newIndex, with: action)

                companyProfileRepository.moveCompanyProfile(from: index, to: newIndex)
        }
    }
    
    func fetchLogo(withSize size: Double, for indexPath: IndexPath) {
        let url = watchlist[indexPath.row].logoLink
        
        Task {
            await requestImage(imageLink: url, imageSize: size, indexPath: indexPath)
        }
    }
    
    func fetchQuotes(for company: CompanyProfileViewModel, at indexPath: IndexPath) {
        Task {
            await requestCompanyQuotes(with: company.tickerSymbol, forIndexPath: indexPath)
        }
    }
    
    func onlineUpdateBegin() {
        webSocketService.initialCompanies = watchlist.map { $0.tickerSymbol }
        webSocketService.openConnection()
        webSocketService.receivedData = { [weak self] trades in
            trades.forEach {
                if let self = self,
                   let index = self.companyIndexInWatchlist[$0.ticker] {

                    let companyQuotes = self.watchlist[index].companyQuotes?.patch(currentPrice: $0.price)
                    self.watchlist[index] = self.watchlist[index].copy(with: companyQuotes)
                }
            }
        }
        
        tradesTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateQuotes()
            }
        }
        tradesTimer?.tolerance = 1
    }
    
    func onlineUpdateEnd() {
        tradesTimer?.invalidate()
        webSocketService.closeConnection()
    }
    
    func cellTapped(at index: Int) {
        let company = watchlist[index]
        coordinator.showCompanyDetails(company)
    }
    
    // MARK: - Private Methods
    private func updateQuotes() {
        watchlist.enumerated().forEach { index, company in
            view?.updateQuotes(company.companyQuotes, at: IndexPath(row: index, section: 0))
        }
    }
    
    private func subscribeToCompanyProfileChanges() {
        Task {
            companyProfilesSubscriber = await companyProfileRepository
                .getCompanyProfilesPublusher()
                .sink { [weak self] in self?.updateWatchlist(with: $0) }
        }
    }

    private func updateWatchlist(with companyProfiles: [CompanyProfileModel]) {

        watchlist = companyProfiles.map {
            CompanyProfileViewModel(companyProfile: $0, inWatchlist: true)
        }

        watchlist.enumerated().forEach { index, company in
            companyIndexInWatchlist[company.tickerSymbol] = index
        }
    }

    private func requestCompanySearch(with symbol: String) async {
        do {
            let companiesModel = try await CompanySearchRequestFactory
                .createRequest(searchSymbol: symbol)
                .execute()

            let internalSearchResults = internalSearchResults.map({$0.ticker})
            let result = Set(internalSearchResults)

            externalSearchResults = companiesModel.companies.filter { !result.contains($0.ticker) }

            DispatchQueue.main.async {
                self.searchView?.updateSearchlist()
            }
        }
        catch {
            handleError(error)
        }
    }

    private func requestCompanyProfile(with tickerSymbol: String) async {
        do {
            let companyProfile = try await CompanyProfileRequestFactory
                .createRequest(tickerSymbol: tickerSymbol)
                .execute()

            let profile = CompanyProfileViewModel(companyProfile: companyProfile, inWatchlist: true)

            watchlist.append(profile)
            companyIndexInWatchlist[profile.tickerSymbol] = watchlist.count-1

            DispatchQueue.main.async {
                self.view?.updateWatchlist(at: self.watchlist.count - 1, to: nil, with: .insert)
            }

            webSocketService.subscribeTo(companyTicker: profile.tickerSymbol)
            companyProfileRepository.putCompanyProfile(companyProfile)
        }
        catch {
            handleError(error)
        }
    }

    private func requestCompanyQuotes(with tickerSymbol: String, forIndexPath indexPath: IndexPath) async {
        do {
            let companyQuotes = try await CompanyQuotesRequestFactory
                .createRequest(tickerSymbol: tickerSymbol)
                .execute()

            self.watchlist[indexPath.row] = self.watchlist[indexPath.row].copy(with: companyQuotes)

            DispatchQueue.main.async {
                self.view?.updateQuotes(companyQuotes, at: indexPath)
            }
        }
        catch {
            handleError(error)
        }
    }

    private func requestImage(imageLink: URL, imageSize: Double, indexPath: IndexPath) async {
        do {
            let image = try await ImageRequestFactory
                .createRequest(imageLink: imageLink, imageSize: CGFloat(imageSize))
                .execute()

            DispatchQueue.main.async {
                self.view?.showLogo(image, at: indexPath)
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
