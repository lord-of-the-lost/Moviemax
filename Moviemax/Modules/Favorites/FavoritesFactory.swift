//
//  FavoritesFactory.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

enum FavoritesFactory {
    static func build(_ dependency: DI) -> FavoritesViewController {
        let router = FavoritesRouter(dependency: dependency)
        let presenter = FavoritesPresenter(router: router, dependency: dependency)
        let viewController = FavoritesViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
