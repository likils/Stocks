//
//  StocksCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol StocksCoordination: NavCoordination {
    
}

class StocksCoordinator: StocksCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let newsService: NewsService
    private let currencyService: CurrencyService
    private let cacheService: CacheService
    
    // MARK: - Init
    init(navController: UINavigationController, newsService: NewsService, currencyService: CurrencyService, cacheService: CacheService) {
        self.navController = navController
        self.newsService = newsService
        self.currencyService = currencyService
        self.cacheService = cacheService
    }
    
    // MARK: - Public methods
    func start() {
        
    }
    
}
