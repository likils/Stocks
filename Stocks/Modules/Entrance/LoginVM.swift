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
    private let loginService: LoginService
    
    // MARK: - Init
    init(coordinator: NavCoordination, loginService: LoginService) {
        self.coordinator = coordinator
        self.loginService = loginService
    }
    
    // MARK: - Public methods
    func login(with type: SocialButton.SocialType) {
        
        
        loginService.login()
        
        loginService.didSignUp = { [unowned self] userId, token, userEmail, firstName, lastName in
            print(userId)
            print(token ?? "token")
            print(userEmail ?? "userEmail")
            print(firstName ?? "firstName")
            print(lastName ?? "lastName")
            self.coordinator?.didFinishClosure?()
        }
        
        loginService.didSignIn = { [unowned self] username, password in
            print(username)
            print(password)
            self.coordinator?.didFinishClosure?()
        }
        
    }
    
}
