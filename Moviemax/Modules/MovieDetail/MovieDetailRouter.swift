//
//  MovieDetailRouter.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

final class MovieDetailRouter: RouterProtocol {
    weak var viewController: MovieDetailViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToMain() {
        let tabBarController = TabBarFactory.build(dependency)
        viewController?.view.window?.rootViewController = tabBarController
    }
}
