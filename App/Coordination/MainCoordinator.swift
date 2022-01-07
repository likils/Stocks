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
    
    // MARK: - Construction
    init(tabController: UITabBarController, serviceContainer: ServiceContainer) {
        self.tabController = tabController
        self.serviceContainer = serviceContainer
        
        let newsNC = UINavigationController()
        newsNC.tabBarItem.title = "News"
        newsNC.tabBarItem.image = UIImage(systemName: "newspaper")
        newsNC.navigationBar.prefersLargeTitles = true
        newsCoordinator = NewsCoordinator(navController: newsNC,
                                          cacheService: serviceContainer.cacheService)
        
        let stocksNC = UINavigationController()
        stocksNC.tabBarItem.title = "Stocks"
        stocksNC.tabBarItem.image = UIImage(systemName: "briefcase")
        stocksNC.navigationBar.prefersLargeTitles = true
        stocksCoordinator = StocksCoordinator(navController: stocksNC,
                                              currencyService: serviceContainer.currencyService,
                                              cacheService: serviceContainer.cacheService,
                                              stocksService: serviceContainer.stocksService,
                                              webSocketService: serviceContainer.webSocketService)
        
        let settingsNC = UINavigationController()
        settingsNC.tabBarItem.title = "Settings"
        settingsNC.tabBarItem.image = UIImage(systemName: "arrow.2.squarepath")
        settingsNC.navigationBar.prefersLargeTitles = true
        settingsCoordinator = SettingsCoordinator(navController: settingsNC)
        
        tabController.viewControllers = [newsNC, stocksNC, settingsNC]
    }
    
    // MARK: - Public Methods
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
