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
    private let service: RequestService
    // TODO: Add login service
    var isLoggedIn = false
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        
        service = RequestService()
        
        tabController = UITabBarController()
        mainCoordinator = MainCoordinator(tabController: tabController, service: service)
    }
    
    // MARK: - Public methods
    func start() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchController = storyboard.instantiateInitialViewController()
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        
        logIn()
    }
    
    // MARK: - Private methods
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
        authCoordinator = AuthCoordinator(navController: navController)
        authCoordinator?.didFinishClosure = { [unowned self] in
            self.authCoordinator = nil
            self.isLoggedIn = true
            self.logIn()
        }
        
        window.rootViewController = navController
        authCoordinator?.start()
    }
    
}
