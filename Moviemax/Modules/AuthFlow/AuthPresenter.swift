//
//  AuthPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class AuthPresenter {
    weak var view: AuthViewController?
    private let router: AuthRouter
    private let authService: AuthenticationService
    
    init(router: AuthRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func forgotPasswordTapped() {
        print(#function)
    }
    
    func googleSignInTapped() {
        print(#function)
    }
    
    func signUpTapped() {
        router.showSignUpFlow()
    }
    
    func signInTapped() {
        router.navigateToMain()
    }
}
