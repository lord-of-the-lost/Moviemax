//
//  SettingsPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

final class SettingsPresenter {
    weak var view: SettingsViewController?
    private let router: SettingsRouter
    private let authService: AuthenticationService
    
    init(router: SettingsRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func getModel() -> SettingsModel {
        return .init(name: "Andy Lexsian", nickname: "@Andy1999", avatar: .avatar)
    }
}
