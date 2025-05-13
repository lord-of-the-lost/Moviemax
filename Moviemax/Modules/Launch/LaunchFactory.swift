//
//  LaunchFactory.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

enum LaunchFactory {
    static func build(_ dependency: DI) -> LaunchViewController {
        let router = LaunchRouter(dependency: dependency)
        let presenter = LaunchPresenter(router: router)
        let viewController = LaunchViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
