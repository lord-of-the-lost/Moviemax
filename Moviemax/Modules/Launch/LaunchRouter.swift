//
//  LaunchRouter.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

final class LaunchRouter: RouterProtocol {
    
    weak var viewController: LaunchViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }

    func navigateToTabbar() {
        let tabBarController = TabBarFactory.build(dependency)
        viewController?.view.window?.rootViewController = tabBarController
    }
}
