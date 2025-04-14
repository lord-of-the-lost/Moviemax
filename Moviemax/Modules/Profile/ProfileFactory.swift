//
//  ProfileFactory.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

enum ProfileFactory {
    static func build(_ dependency: DI) -> ProfileViewController {
        let router = ProfileRouter(dependency: dependency)
        let presenter = ProfilePresenter(router: router, dependency: dependency)
        let viewController = ProfileViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
