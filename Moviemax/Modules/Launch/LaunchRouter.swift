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
    
    func navigateToAuth() {
        let authController = AuthFactory.build(dependency)
        viewController?.view.window?.rootViewController = authController
    }
    
    func navigateToOnboarding() {
        let onboardingController = OnboardingFactory.build(dependency)
        viewController?.view.window?.rootViewController = onboardingController
    }
}
