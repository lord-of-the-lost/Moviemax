//
//  LocalizationManager.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

import Foundation

final class LocalizationManager {
    private let coreDataManager: CoreDataManager
    
    var currentLanguage: AppLanguage {
        get {
            let appState = coreDataManager.getAppStateModel()
            return appState.currentLanguage
        }
        set {
            var appState = coreDataManager.getAppStateModel()
            appState.currentLanguage = newValue
            coreDataManager.updateAppState(with: appState)
        }
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func changeLanguage(to language: AppLanguage) {
        currentLanguage = language
        NotificationCenter.default.post(name: .languageChanged, object: language)
    }
    
    func setLanguage(_ language: AppLanguage) {
        changeLanguage(to: language)
    }
    
    func getCurrentLanguage() -> AppLanguage {
        currentLanguage
    }
}
