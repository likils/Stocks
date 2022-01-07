//
//  StocksCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit
import SafariServices

protocol StocksCoordination: NavCoordination {
    
    func showCompanyDetails(_ company: CompanyProfileViewModel)
    func showWebPage(with url: URL)
    
}

class StocksCoordinator: StocksCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let currencyService: CurrencyService
    private let cacheService: CacheService
    private let stocksService: StocksService
    private let webSocketService: WebSocketService
    
    // MARK: - Construction
    init(navController: UINavigationController,
         currencyService: CurrencyService,
         cacheService: CacheService,
         stocksService: StocksService,
         webSocketService: WebSocketService) {
        
        self.navController = navController
        self.currencyService = currencyService
        self.cacheService = cacheService
        self.stocksService = stocksService
        self.webSocketService = webSocketService
    }
    
    // MARK: - Public Methods
    func start() {
        let vm = StocksVM(coordinator: self,
                          stocksService: stocksService,
                          webSocketService: webSocketService,
                          cacheService: cacheService)
        let vc = StocksVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
    func showCompanyDetails(_ company: CompanyProfileViewModel) {
        let vm = CompanyDetailsVM(coordinator: self,
                                  stocksService: stocksService,
                                  webSocketService: webSocketService,
                                  cacheService: cacheService,
                                  companyProfile: company)
        let vc = CompanyDetailsVC(viewModel: vm)
        
        didFinishClosure = {
            self.navController.popViewController(animated: true)
        }
        
        navController.pushViewController(vc, animated: true)
    }
    
    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        navController.present(vc, animated: true)
    }
    
}
