// ----------------------------------------------------------------------------
//
//  MainCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

final class MainCoordinator: Coordination {

// MARK: - Properties

    var didFinishClosure: (() -> ())?

// MARK: - Private properties

    private let tabController: UITabBarController
    private let serviceContainer: ServiceContainer

    private var newsCoordinator: Coordination?
    private var stocksCoordinator: Coordination?
    private var settingsCoordinator: Coordination?

// MARK: - Construction

    init(tabController: UITabBarController, serviceContainer: ServiceContainer) {
        self.tabController = tabController
        self.serviceContainer = serviceContainer

        setupNewsCoordinator()
        setupStocksCoordinator()
        setupSettingsCoordinator()
    }

// MARK: - Methods

    func start() {
        newsCoordinator?.start()
        stocksCoordinator?.start()
        settingsCoordinator?.start()
    }

// MARK: - Private Methods

    private func setupNewsCoordinator() {

        let newsNC = UINavigationController()
        newsNC.tabBarItem.title = "News"
        newsNC.tabBarItem.image = UIImage(systemName: "newspaper")
        newsNC.navigationBar.prefersLargeTitles = true

        tabController.viewControllers = [newsNC]

        newsCoordinator = NewsCoordinator(navController: newsNC)
    }

    private func setupStocksCoordinator() {

        let stocksNC = UINavigationController()
        stocksNC.tabBarItem.title = "Stocks"
        stocksNC.tabBarItem.image = UIImage(systemName: "briefcase")
        stocksNC.navigationBar.prefersLargeTitles = true

        tabController.viewControllers?.append(stocksNC)

        stocksCoordinator = StocksCoordinator(
            navController: stocksNC,
            webSocketService: serviceContainer.webSocketService
        )
    }

    private func setupSettingsCoordinator() {

        let settingsNC = UINavigationController()
        settingsNC.tabBarItem.title = "Settings"
        settingsNC.tabBarItem.image = UIImage(systemName: "arrow.2.squarepath")
        settingsNC.navigationBar.prefersLargeTitles = true

        tabController.viewControllers?.append(settingsNC)

        settingsCoordinator = SettingsCoordinator(navController: settingsNC)
        settingsCoordinator?.didFinishClosure = { [weak self] in
            self?.didFinishClosure?()
        }
    }
}
