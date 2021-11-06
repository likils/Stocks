//
//  AppleLoginService.swift
//  Stocks
//
//  Created by likils on 30.04.2021.
//

import Foundation
import AuthenticationServices

class AppleLoginService: NSObject, LoginService {
    
    var didSignUp: ((_ userId: String,
                     _ token: String?,
                     _ userEmail: String?,
                     _ firstName: String?,
                     _ lastName: String?)
                    -> ())?
    
    var didSignIn: ((_ username: String,
                     _ password: String)
                    -> ())?
    
    func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.windows.last!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
            // Create an account
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                var token: String?
                if let tokenData = appleIDCredential.authorizationCode {
                    token = String(data: tokenData, encoding: .utf8)
                }
                
                let userID = appleIDCredential.user
                let userEmail = appleIDCredential.email
                let firstName = appleIDCredential.fullName?.givenName
                let lastName = appleIDCredential.fullName?.familyName
                
                didSignUp?(userID, token, userEmail, firstName, lastName)
                
            // Sign in using an existing iCloud Keychain credential. 
            case let passwordCredential as ASPasswordCredential:
                let username = passwordCredential.user
                let password = passwordCredential.password
                
                didSignIn?(username, password)
                
            default:
                break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else { return }
        print(error.localizedDescription)
    }
    
}
