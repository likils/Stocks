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
            DispatchQueue.main.async {
                self?.view?.show(companies: companies)
            }
        }
    }
    
    func fetchQuotes(for company: Company) {
        stocksService.getQuotes(for: company) { quote in
            guard let quote = quote else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.view?.add(company: (company, quote))
            }
        }
    }
    
    func reloadQuotes(for companies: [Company]) {
        var stocks = [(Company, CompanyQuotes?)]()
        
        companies.forEach { company in
            stocksService.getQuotes(for: company) { quote in
                stocks.append((company, quote))
                
                if companies.count == stocks.count {
                    let stocks = stocks.filter { $0.1 != nil }.map { ($0.0, $0.1!) }
                    
                    DispatchQueue.main.async { [weak self] in
                        
                    }
                }
            }
        }
    }
    
}
