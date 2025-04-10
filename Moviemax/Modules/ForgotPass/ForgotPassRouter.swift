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
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    init(dependency: DI) {
        self.dependency = dependency
    }
}
