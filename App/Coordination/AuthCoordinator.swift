//
//  AuthCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol AuthCoordination: NavCoordination {
    
    
    
}

class AuthCoordinator: AuthCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let loginService: LoginService
    
    // MARK: - Construction
    init(navController: UINavigationController, loginService: LoginService) {
        self.navController = navController
        self.loginService = loginService
    }
    
    // MARK: - Public Methods
    func start() {
        let vm = LoginVM(coordinator: self, loginService: loginService)
        let vc = LoginVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
