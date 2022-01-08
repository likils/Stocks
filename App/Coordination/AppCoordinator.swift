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
    
    // MARK: - Construction
    init(window: UIWindow) {
        self.window = window

        let webSocketService = WebSocketServiceImpl()
        let cacheService = CacheServiceImpl()
        serviceContainer = ServiceContainerImpl(webSocketService: webSocketService, cacheService: cacheService)
        
        tabController = UITabBarController()
        mainCoordinator = MainCoordinator(tabController: tabController, serviceContainer: serviceContainer)
    }
    
    // MARK: - Public Methods
    func start() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchController = storyboard.instantiateInitialViewController()
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        
        showMain()
    }
    
    // MARK: - Private Methods
    
    private func showMain() {
        window.rootViewController = tabController
        mainCoordinator.start()
    }
    
}
