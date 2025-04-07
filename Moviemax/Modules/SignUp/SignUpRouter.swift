//
//  SingUpRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

final class SignUpRouter: RouterProtocol {
    weak var viewController: SignUpViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToMain() {
        let tabBarController = TabBarFactory.build(dependency)
        viewController?.view.window?.rootViewController = tabBarController
    }
    
    func showAuthFlow() {
        let authViewController = AuthFactory.build(dependency)
        viewController?.view.window?.rootViewController = authViewController
    }
}
