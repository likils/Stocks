//
//  StocksVM.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import Foundation

class StocksVM: StocksViewModel {
    
    // MARK: - Public properties
    weak var view: StocksView?
    
    //MARK: - Private properties
    private let coordinator: StocksCoordination
    private let stocksService: StocksService
    
    // MARK: - Init
    init(coordinator: StocksCoordination, stocksService: StocksService) {
        self.coordinator = coordinator
        self.stocksService = stocksService
    }
    
    // MARK: - Public methods
    func searchCompany(_ name: String) {
        stocksService.searchCompany(with: name) { [weak self] companies in
            var stocks = [(Company, CompanyQuotes?)]()
            
            companies.forEach { company in
                self?.stocksService.getQuotes(for: company) { quote in
                    stocks.append((company, quote))
                    
                    if companies.count == stocks.count {
                        let stocks = stocks.filter { $0.1 != nil }.map { ($0.0, $0.1!) }
                        DispatchQueue.main.async {
                            self?.view?.showSearchResult(with: stocks)
                        }
                    }
                }
            }
        }
    }
    
}
