//
//  MainCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class MainCoordinator: Coordination {
    
    // MARK: - Public properties
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let newsCoordinator: NewsCoordination
    private let stocksCoordinator: StocksCoordination
    private let settingsCoordinator: SettingsCoordination
    private let tabController: UITabBarController
    private let serviceContainer: ServiceContainer
    
    // MARK: - Init
    init(tabController: UITabBarController, serviceContainer: ServiceContainer) {
        self.tabController = tabController
        self.serviceContainer = serviceContainer
        
        let newsNC = UINavigationController()
        newsNC.title = nil
        newsNC.tabBarItem.title = "News"
        newsCoordinator = NewsCoordinator(navController: newsNC,
                                          newsService: serviceContainer.newsService,
                                          cacheService: serviceContainer.cacheService)
        
        let stocksNC = UINavigationController()
        stocksNC.tabBarItem.title = "Stocks"
        stocksCoordinator = StocksCoordinator(navController: stocksNC,
                                              newsService: serviceContainer.newsService,
                                              currencyService: serviceContainer.currencyService,
                                              cacheService: serviceContainer.cacheService,
                                              stocksService: serviceContainer.stocksService)
        
        let settingsNC = UINavigationController()
        settingsNC.tabBarItem.title = "Settings"
        settingsCoordinator = SettingsCoordinator(navController: settingsNC)
        
        tabController.viewControllers = [newsNC, stocksNC, settingsNC]
    }
    
    // MARK: - Public methods
    func start() {
        newsCoordinator.start()
        stocksCoordinator.start()
        settingsCoordinator.start()
        settingsCoordinator.didFinishClosure = { [unowned self] in
            self.didFinishClosure?()
        }
        tabController.selectedIndex = 0
    }
    
}
