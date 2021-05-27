//
//  StocksCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit
import SafariServices

protocol StocksCoordination: NavCoordination {
    
    func showWebPage(with url: URL)
    
}

class StocksCoordinator: StocksCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let newsService: NewsService
    private let currencyService: CurrencyService
    private let cacheService: CacheService
    private let stocksService: StocksService
    private let webSocketService: WebSocketService
    
    // MARK: - Init
    init(navController: UINavigationController,
         newsService: NewsService,
         currencyService: CurrencyService,
         cacheService: CacheService,
         stocksService: StocksService,
         webSocketService: WebSocketService) {
        
        self.navController = navController
        self.newsService = newsService
        self.currencyService = currencyService
        self.cacheService = cacheService
        self.stocksService = stocksService
        self.webSocketService = webSocketService
    }
    
    // MARK: - Public methods
    func start() {
        let vm = StocksVM(coordinator: self,
                          stocksService: stocksService,
                          webSocketService: webSocketService,
                          cacheService: cacheService)
        let vc = StocksVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        navController.present(vc, animated: true)
    }
    
}
