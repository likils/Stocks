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

    private var mainCoordinator: Coordination?
    
// MARK: - Construction

    init(window: UIWindow) {
        self.window = window
        
        setupMainCoordinator()
    }

// MARK: - Methods

    func start() {
        mainCoordinator?.start()
    }

// MARK: - Private Methods

    private func setupMainCoordinator() {

        let tabController = UITabBarController()
        window.rootViewController = tabController
        window.makeKeyAndVisible()

        let serviceContainer = createServiceContainer()

        mainCoordinator = MainCoordinator(tabController: tabController, serviceContainer: serviceContainer)
        mainCoordinator?.didFinishClosure = { [weak self] in
            self?.setupMainCoordinator()
            self?.mainCoordinator?.start()
        }
    }

    private func createServiceContainer() -> ServiceContainer {
        return ServiceContainerImpl(webSocketService: WebSocketServiceImpl())
    }
}
