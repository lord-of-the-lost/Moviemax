//
//  SettingsRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

import UIKit

final class SettingsRouter: RouterProtocol {
    weak var viewController: SettingsViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func showAuthFlow() {
        let authViewController = AuthFactory.build(dependency)
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
    
    func showProfile() {
        let profileViewController = ProfileFactory.build(dependency)
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showChangePass() {
        let changePassController = ChangePassFactory.build(dependency)
        viewController?.navigationController?.pushViewController(changePassController, animated: true)
    }
}
