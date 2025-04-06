//
//  ThemeManager.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

import Foundation

final class ThemeManager {
    private let coreDataManager: CoreDataManager
    
    var currentTheme: AppTheme {
        get {
            let appState = coreDataManager.getAppStateModel()
            return appState.currentTheme
        }
        set {
            var appState = coreDataManager.getAppStateModel()
            appState.currentTheme = newValue
            coreDataManager.updateAppState(with: appState)
        }
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func applyTheme(_ theme: AppTheme) {
        currentTheme = theme
        NotificationCenter.default.post(name: .themeChanged, object: theme)
    }
    
    func toggleTheme() {
        let newTheme: AppTheme = currentTheme == .light ? .dark : .light
        applyTheme(newTheme)
    }
}
