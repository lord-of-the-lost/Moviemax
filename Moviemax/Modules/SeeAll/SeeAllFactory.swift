//
//  SeeAllFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

enum SeeAllFactory {
    static func build(_ dependency: DI) -> SeeAllViewController {
        let router = SeeAllRouter(dependency: dependency)
        let presenter = SeeAllPresenter(router: router, dependency: dependency)
        let viewController = SeeAllViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
