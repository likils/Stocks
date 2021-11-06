//
//  LoginService.swift
//  Stocks
//
//  Created by likils on 30.04.2021.
//

import Foundation

protocol LoginService: AnyObject {
    
    var didSignUp: ((_ userId: String,
                    _ token: String?,
                    _ userEmail: String?,
                    _ firstName: String?,
                    _ lastName: String?)
                   -> ())? { get set }
    
    var didSignIn: ((_ username: String,
                     _ password: String)
                    -> ())? { get set }
    
    func login()
    
}
