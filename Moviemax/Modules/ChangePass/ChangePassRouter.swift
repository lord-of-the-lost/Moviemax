//
//  ChangePassRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

final class ChangePassRouter: RouterProtocol {
    weak var viewController: ChangePassViewController?
    private let dependency: DI
    
    func navigateToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    init(dependency: DI) {
        self.dependency = dependency
    }
}
