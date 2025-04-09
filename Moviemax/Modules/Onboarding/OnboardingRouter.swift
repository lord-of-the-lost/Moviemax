//
//  OnboardingRouter.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

import Foundation

final class OnboardingRouter: RouterProtocol {
    
    weak var viewController: OnboardingViewController?
    private let dependency: DI
    
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToAuth() {
        let authController = AuthFactory.build(dependency)
        viewController?.view.window?.rootViewController = authController
    }
}

