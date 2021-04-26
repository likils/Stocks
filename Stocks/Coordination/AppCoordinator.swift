//
//  AppCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class AppCoordinator: WindowCoordinator {
    
    // MARK: - Public properties
    var window: UIWindow
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let service: RequestService
    private let mainCoordinator: TabCoordinator
    private let tabBarController: UITabBarController
    // TODO: Add login service
    private var isLoggedIn = true
    
    // MARK: - Init
    init(window: UIWindow, service: RequestService) {
        self.window = window
        self.service = service
        
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        mainCoordinator = MainCoordinator(tabController: tabBarController, service: service)
    }
    
    // MARK: - Public methods
    func start() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchController = storyboard.instantiateInitialViewController()
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        
        if isLoggedIn {
            showMain()
        } else {
            showRegistration()
        }
    }
    
    // MARK: - Private methods
    private func showMain() {
        mainCoordinator.start()
        window.rootViewController = tabBarController
    }
    
    private func showRegistration() {
        
    }
    
}
