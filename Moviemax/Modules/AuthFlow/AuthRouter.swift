//
//  AuthRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

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
}
