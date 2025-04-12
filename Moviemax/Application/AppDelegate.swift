//
//  AppDelegate.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let dependency = DI()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        setupAppearance()
        setupObservers()
        
        let appRouter = AppRouter(window: window, dependency: dependency)
        appRouter.start()
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Проверяем, нужно ли выполнить автоматический выход
        if dependency.authService.shouldAutoLogout() {
            dependency.authService.logout()
        }
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func setupAppearance() {
        let currentTheme = dependency.themeManager.getCurrentTheme()
        applyTheme(currentTheme)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeChanged,
            object: nil
        )
    }
    
    func applyTheme(_ theme: AppTheme) {
        switch theme {
        case .light:
            window?.overrideUserInterfaceStyle = .light
        case .dark:
            window?.overrideUserInterfaceStyle = .dark
        }
    }
    
    @objc func themeDidChange(_ notification: Notification) {
        guard let theme = notification.object as? AppTheme else { return }
        applyTheme(theme)
    }
}

