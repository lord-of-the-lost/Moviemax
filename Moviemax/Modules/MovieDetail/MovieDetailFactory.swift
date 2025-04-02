//
//  MovieDetailFactory.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

enum MovieDetailFactory {
    static func build(_ dependency: DI) -> MovieDetailViewController {
        let router = MovieDetailRouter(dependency: dependency)
        let presenter = MovieDetailPresenter(router: router, dependency: dependency)
        let viewController = MovieDetailViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
