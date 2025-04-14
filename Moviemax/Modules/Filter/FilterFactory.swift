//
//  FilterFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

enum FilterFactory {
    static func build(_ dependency: DI) -> FilterViewController {
        let router = FilterRouter(dependency: dependency)
        let presenter = FilterPresenter(router: router, dependency: dependency)
        let viewController = FilterViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
