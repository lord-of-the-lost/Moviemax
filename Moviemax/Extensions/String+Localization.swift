//
//  String+Localization.swift
//  Moviemax
//
//  Created by Николай Игнатов on 12.04.2025.
//

import UIKit

extension String {
    /// Локализованная версия строки
    func localized() -> String {
        guard let localizationManager = (UIApplication.shared.delegate as? AppDelegate)?.dependency.localizationManager else {
            return NSLocalizedString(self, comment: "")
        }
        return localizationManager.localizedString(for: self)
    }
    
    /// Статический метод для локализации
    static func localized(_ key: String) -> String {
        return key.localized()
    }
} 