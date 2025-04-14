//
//  ChangePassFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

enum ChangePassFactory {
    static func build(_ dependency: DI) -> ChangePassViewController {
        let router = ChangePassRouter(dependency: dependency)
        let presenter = ChangePassPresenter(router: router, dependency: dependency)
        let viewController = ChangePassViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
