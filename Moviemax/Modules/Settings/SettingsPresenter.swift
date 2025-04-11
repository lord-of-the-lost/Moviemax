//
//  SettingsPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

import UIKit

final class SettingsPresenter {
    weak var view: SettingsViewController?
    private let router: SettingsRouter
    private let authService: AuthenticationService
    private let userService: UserService
    private let themeManager: ThemeManager
    private let localizationManager: LocalizationManager
    
    init(router: SettingsRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
        self.userService = dependency.userService
        self.themeManager = dependency.themeManager
        self.localizationManager = dependency.localizationManager
    }
    
    func viewWillAppear() {
        loadUserData()
        loadAppSettings()
    }
    
    func logOutTapped() {
        authService.logout()
        router.showAuthFlow()
    }
    
    func showProfileTapped() {
        router.showProfile()
    }
    
    func toggleDarkMode(isEnabled: Bool) {
        let theme: AppTheme = isEnabled ? .dark : .light
        themeManager.setTheme(theme)
    }
    
    func setLanguage(language: AppLanguage) {
        localizationManager.setLanguage(language)
    }
}

// MARK: - Private Methods
private extension SettingsPresenter {
    func loadUserData() {
        guard let currentUser = userService.getCurrentUser() else {
            router.showAuthFlow()
            return
        }
        
        let fullName = "\(currentUser.firstName) \(currentUser.lastName)"
        view?.updateUserInfo(name: fullName, nickname: currentUser.email)
        
        setUserAvatar(from: currentUser.avatar)
    }
    
    func setUserAvatar(from data: Data?) {
        guard
            let data,
            let avatarImage = UIImage(data: data)
        else {
            view?.updateUserAvatar(image: UIImage(resource: .profilePlaceholder))
            return
        }
        view?.updateUserAvatar(image: avatarImage)
    }
    
    func loadAppSettings() {
        let isDarkMode = themeManager.getCurrentTheme() == .dark
        let currentLanguage = localizationManager.getCurrentLanguage()
        
        view?.updateAppSettings(isDarkMode: isDarkMode, language: currentLanguage)
    }
}
