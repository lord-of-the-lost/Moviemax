//
//  SettingsRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

final class SettingsRouter: RouterProtocol {
    weak var viewController: SettingsViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
}
