//
//  RecentWatchFactory.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

enum RecentWatchFactory {
    static func build(_ dependency: DI) -> RecentWatchViewController {
        let router = RecentWatchRouter(dependency: dependency)
        let presenter = RecentWatchPresenter(router: router, dependency: dependency)
        let viewController = RecentWatchViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
