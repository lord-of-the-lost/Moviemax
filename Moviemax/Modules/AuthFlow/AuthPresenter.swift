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
    private let authorizationService: AuthorizationService
    
    init(router: AuthRouter, dependency: DI) {
        self.router = router
        self.authorizationService = dependency.authorizationService
    }
    
    func loginButtonTapped() {
        authorizationService.login()
        router.navigateToMain()
    }
}
