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
    private let service: RequestService
    
    // MARK: - Init
    init(tabController: UITabBarController, service: RequestService) {
        self.tabController = tabController
        self.service = service
        
        let newsNC = UINavigationController()
        newsNC.title = nil
        newsNC.tabBarItem.title = "News"
        newsCoordinator = NewsCoordinator(navController: newsNC, service: service)
        
        let stocksNC = UINavigationController()
        stocksNC.tabBarItem.title = "Stocks"
        stocksCoordinator = StocksCoordinator(navController: stocksNC, service: service)
        
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
