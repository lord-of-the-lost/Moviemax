//
//  ForgotPassFactory.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

enum ForgotPassFactory {
    static func build(_ dependency: DI) -> ForgotPassViewController {
        let router = ForgotPassRouter(dependency: dependency)
        let presenter = ForgotPassPresenter(router: router, dependency: dependency)
        let viewController = ForgotPassViewController(presenter: presenter)
        
        router.viewController = viewController
        return viewController
    }
}
