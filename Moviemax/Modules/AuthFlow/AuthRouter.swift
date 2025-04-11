//
//  AuthRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class AuthRouter: RouterProtocol {
    weak var viewController: AuthViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToMain() {
        let tabBarController = TabBarFactory.build(dependency)
        viewController?.view.window?.rootViewController = tabBarController
    }
    
    func showSignUpFlow() {
        let signUpViewController = SignUpFactory.build(dependency)
        viewController?.view.window?.rootViewController = signUpViewController
    }
    
    func showForgotPassFlow() {
        let forgotPassViewController = ForgotPassFactory.build(dependency)
        let navigationController = UINavigationController(rootViewController: forgotPassViewController)
        viewController?.view.window?.rootViewController = navigationController
    }
}
