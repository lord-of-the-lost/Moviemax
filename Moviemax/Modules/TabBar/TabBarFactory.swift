//
//  TabBarFactory.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

enum TabBarFactory {
    static func build(_ dependency: DI) -> TabBarController {
        let router = TabBarRouter(dependency: dependency)
        let presenter = TabBarPresenter(router: router, dependency: dependency)
        let viewController = TabBarController(presenter: presenter)
        presenter.view = viewController
        router.viewController = viewController
        presenter.configureTabBar()
        return viewController
    }
}
