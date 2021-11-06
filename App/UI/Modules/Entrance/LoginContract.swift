//
//  LoginContract.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import Foundation

protocol LoginViewModel: AnyObject {
    
    func login(with type: SocialButton.SocialType)
    
}
