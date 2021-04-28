//
//  AuthCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class AuthCoordinator: NavCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public methods
    func start() {
        let vm = LoginVM(coordinator: self)
        let vc = LoginVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
