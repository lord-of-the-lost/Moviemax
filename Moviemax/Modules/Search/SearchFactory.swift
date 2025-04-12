//
//  SearchFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

enum SearchFactory {
    static func build(_ dependency: DI) -> SearchViewController {
        let router = SearchRouter(dependency: dependency)
        let presenter = SearchPresenter(router: router, dependency: dependency)
        let viewController = SearchViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
