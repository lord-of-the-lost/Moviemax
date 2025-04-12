//
//  ForgotPassRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

final class ForgotPassRouter: RouterProtocol {
    weak var viewController: ForgotPassViewController?
    private let dependency: DI
    
    func navigateToBack() {
        let authViewController = AuthFactory.build(dependency)
        viewController?.view.window?.rootViewController = authViewController
    }
    
    init(dependency: DI) {
        self.dependency = dependency
    }
}
