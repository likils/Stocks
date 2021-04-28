//
//  LoginVM.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import Foundation

class LoginVM: LoginViewModel {
    
    // MARK: - Private properties
    private weak var coordinator: NavCoordination?
    
    // MARK: - Init
    init(coordinator: NavCoordination) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    func login() {
        coordinator?.didFinishClosure?()
    }
    
}
