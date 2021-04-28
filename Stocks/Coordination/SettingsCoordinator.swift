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
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public methods
    func start() {
        let vm = SettingsVM(coordinator: self)
        let vc = SettingsVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
