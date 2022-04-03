// ----------------------------------------------------------------------------
//
//  AppCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

final class AppCoordinator {

    // MARK: - Private Properties

    private let window: UIWindow

    private var mainCoordinator: Coordinator?

    // MARK: - Construction

    init(window: UIWindow) {
        self.window = window

        setupMainCoordinator()
    }

    // MARK: - Methods

    func start() {
        self.mainCoordinator?.start()
    }

    // MARK: - Private Methods

    private func setupMainCoordinator() {

        let tabController = UITabBarController()
        self.window.rootViewController = tabController
        self.window.makeKeyAndVisible()

        mainCoordinator = MainCoordinator(tabController: tabController)
        mainCoordinator?.didFinishClosure = { [weak self] in
            self?.setupMainCoordinator()
            self?.mainCoordinator?.start()
        }
    }
}
