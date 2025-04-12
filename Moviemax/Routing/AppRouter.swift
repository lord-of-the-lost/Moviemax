//
//  AppRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class AppRouter {
    weak var window: UIWindow?
    private let dependency: DI
    
    init(window: UIWindow?, dependency: DI) {
        self.window = window
        self.dependency = dependency
    }
    
    func start() {
        if dependency.authService.isAuthorized {
            showLaunchFlow()
        } else {
            if !UserDefaults.standard.bool(forKey: "onboardingWasShown") {
                UserDefaults.standard.set(true, forKey: "onboardingWasShown")
                showOnboardingFlow()
            }
            else {
                showAuthFlow()
            }
        }
    }
}

// MARK: - Private Methods
private extension AppRouter {
    func showMainFlow() {
        let tabBarController = TabBarFactory.build(dependency)
        window?.rootViewController = tabBarController
    }
    
    func showAuthFlow() {
        let authViewController = AuthFactory.build(dependency)
        let navigationController = UINavigationController(rootViewController: authViewController)
        window?.rootViewController = navigationController
    }
    
    func showOnboardingFlow() {
        let onboardingViewController = OnboardingFactory.build(dependency)
        let navigationController = UINavigationController(rootViewController: onboardingViewController)
        window?.rootViewController = navigationController
    }
    
    func showLaunchFlow() {
        let launchViewController = LaunchFactory.build(dependency)
        let navigationController = UINavigationController(rootViewController: launchViewController)
        window?.rootViewController = navigationController
    }
}
