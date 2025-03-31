//
//  AuthFactory.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

enum AuthFactory {
    static func build(_ dependency: DI) -> AuthViewController {
        let router = AuthRouter(dependency: dependency)
        let presenter = AuthPresenter(router: router, dependency: dependency)
        let viewController = AuthViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
