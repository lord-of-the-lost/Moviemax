//
//  ProfileRouter.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

final class ProfileRouter: RouterProtocol {
    
    weak var viewController: ProfileViewController?
    private let dependency: DI
    
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
