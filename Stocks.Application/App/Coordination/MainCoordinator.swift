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

final class MainCoordinator: Coordinator {

    // MARK: - Properties

    var didFinishClosure: (() -> ())?

    // MARK: - Private properties

    private let tabController: UITabBarController

    private var newsCoordinator: Coordinator?
    private var stocksCoordinator: Coordinator?
    private var settingsCoordinator: Coordinator?

    // MARK: - Construction

    init(tabController: UITabBarController) {
        self.tabController = tabController

        setupNewsCoordinator()
        setupStocksCoordinator()
        setupSettingsCoordinator()
    }

    // MARK: - Methods

    func start() {
        self.newsCoordinator?.start()
        self.stocksCoordinator?.start()
        self.settingsCoordinator?.start()
    }

    // MARK: - Private Methods

    private func setupNewsCoordinator() {

        let newsNC = UINavigationController()
        newsNC.tabBarItem.title = "News"
        newsNC.tabBarItem.image = UIImage(systemName: "newspaper")
        newsNC.navigationBar.prefersLargeTitles = true

        self.tabController.viewControllers = [newsNC]

        self.newsCoordinator = NewsCoordinator(navController: newsNC)
    }

    private func setupStocksCoordinator() {

        let stocksNC = UINavigationController()
        stocksNC.tabBarItem.title = "Stocks"
        stocksNC.tabBarItem.image = UIImage(systemName: "briefcase")
        stocksNC.navigationBar.prefersLargeTitles = true

        self.tabController.viewControllers?.append(stocksNC)

        self.stocksCoordinator = StocksCoordinator(navController: stocksNC)
    }

    private func setupSettingsCoordinator() {

        let settingsNC = UINavigationController()
        settingsNC.tabBarItem.title = "Settings"
        settingsNC.tabBarItem.image = UIImage(systemName: "arrow.2.squarepath")
        settingsNC.navigationBar.prefersLargeTitles = true

        self.tabController.viewControllers?.append(settingsNC)

        self.settingsCoordinator = SettingsCoordinator(navController: settingsNC)
        self.settingsCoordinator?.didFinishClosure = { [weak self] in
            self?.didFinishClosure?()
        }
    }
}
