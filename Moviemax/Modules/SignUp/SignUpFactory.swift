//
//  SignUpFactory.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

enum SignUpFactory {
    static func build(_ dependency: DI) -> SignUpViewController {
        let router = SignUpRouter(dependency: dependency)
        let presenter = SignUpPresenter(router: router, dependency: dependency)
        let viewController = SignUpViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
