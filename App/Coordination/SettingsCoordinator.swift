//
//  SettingsCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol SettingsCoordination: NavCoordination {
    
}

class SettingsCoordinator: SettingsCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    
    // MARK: - Construction
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public Methods
    func start() {
        let vm = SettingsVM(coordinator: self)
        let vc = SettingsVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
