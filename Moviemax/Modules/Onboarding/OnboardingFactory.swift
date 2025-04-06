//
//  OnboardingFactory.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

enum OnboardingFactory {
    static func build(_ dependency: DI) -> OnboardingViewController {
        let router = OnboardingRouter(dependency: dependency)
        let presenter = OnboardingPresenter(router: router, dependency: dependency)
        let viewController = OnboardingViewController(presenter: presenter)
        
        router.viewController = viewController
        presenter.view = viewController
        return viewController
    }
}
