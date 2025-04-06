//
//  SettingsFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

enum SettingsFactory {
    static func build(_ dependency: DI) -> SettingsViewController {
        let router = SettingsRouter(dependency: dependency)
        let presenter = SettingsPresenter(router: router, dependency: dependency)
        let viewController = SettingsViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
