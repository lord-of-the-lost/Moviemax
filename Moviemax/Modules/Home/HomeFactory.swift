//
//  HomeFactory.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import UIKit

enum HomeFactory {
    static func build(_ dependency: DI) -> HomeViewController {
        let router = HomeRouter(dependency: dependency)
        let presenter = HomePresenter(router: router)
        let viewController = HomeViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}

