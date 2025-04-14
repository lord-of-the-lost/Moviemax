//
//  LocalizationManager.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

import Foundation

final class LocalizationManager {
    private let coreDataManager: CoreDataManager
    
    // Текущий язык приложения
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
    
    // Словарь для хранения локализованных строк
    private var localizationBundle: Bundle?
    
    // Инициализация
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        updateLanguageBundle()
    }
    
    // Основной метод для получения локализованной строки
    func localizedString(for key: String) -> String {
        // Берем сначала из нашего бандла, если удалось его подготовить
        if let bundle = localizationBundle {
            let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
            if localizedString != key {
                return localizedString
            }
        }
        
        // Иначе используем стандартный механизм
        return NSLocalizedString(key, comment: "")
    }
    
    // Метод для смены языка
    func changeLanguage(to language: AppLanguage) {
        // Сохраняем выбранный язык
        currentLanguage = language
        
        // Обновляем бандл с переводами
        updateLanguageBundle()
        
        // Уведомляем систему о смене языка
        NotificationCenter.default.post(name: .languageChanged, object: language)
    }
    
    func setLanguage(_ language: AppLanguage) {
        changeLanguage(to: language)
    }
    
    func getCurrentLanguage() -> AppLanguage {
        currentLanguage
    }
    
    // MARK: - Private Methods
    
    // Обновляем бандл с переводами для текущего языка
    private func updateLanguageBundle() {
        // Идентификатор языка для iOS
        let languageID: String
        
        switch currentLanguage {
        case .russian:
            languageID = "ru"
        case .english:
            languageID = "en"
        }
        
        // Пытаемся найти путь к ресурсам для выбранного языка
        if let path = Bundle.main.path(forResource: languageID, ofType: "lproj") {
            localizationBundle = Bundle(path: path)
        } else {
            localizationBundle = nil
        }
    }
}
