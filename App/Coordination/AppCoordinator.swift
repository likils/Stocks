//
//  AppCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class AppCoordinator {
    
    // MARK: - Private properties
    private let window: UIWindow
    private var authCoordinator: NavCoordination?
    private let mainCoordinator: Coordination
    private let tabController: UITabBarController
    private let serviceContainer: ServiceContainer
    // TODO: Add login service
    private var isLoggedIn = true
    
    // MARK: - Construction
    init(window: UIWindow) {
        self.window = window
        
        let loginService = AppleLoginService()
        let newsService = NewsServiceImpl()
        let stocksService = StocksServiceImpl()
        let webSocketService = WebSocketServiceImpl()
        let currencyService = CurrencyServiceImpl()
        let cacheService = CacheServiceImpl()
        serviceContainer = ServiceContainerImpl(loginService: loginService,
                                                newsService: newsService,
                                                stocksService: stocksService,
                                                webSocketService: webSocketService,
                                                currencyService: currencyService,
                                                cacheService: cacheService)
        
        tabController = UITabBarController()
        mainCoordinator = MainCoordinator(tabController: tabController, serviceContainer: serviceContainer)
    }
    
    // MARK: - Public Methods
    func start() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchController = storyboard.instantiateInitialViewController()
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        
        logIn()
    }
    
    // MARK: - Private Methods
    private func logIn() {
        isLoggedIn ? showMain() : showRegistration()
    }
    
    private func showMain() {
        mainCoordinator.didFinishClosure = { [unowned self] in
            self.isLoggedIn = false
            self.logIn()
        }
        window.rootViewController = tabController
        mainCoordinator.start()
    }
    
    private func showRegistration() {
        let navController = UINavigationController()
        authCoordinator = AuthCoordinator(navController: navController, loginService: serviceContainer.loginService)
        authCoordinator?.didFinishClosure = { [unowned self] in
            self.authCoordinator = nil
            self.isLoggedIn = true
            self.logIn()
        }
        
        window.rootViewController = navController
        authCoordinator?.start()
    }
    
}
