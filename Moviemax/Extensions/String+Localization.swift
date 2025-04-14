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
        // Используем синхронный вызов на главном потоке
        if Thread.isMainThread {
            guard let localizationManager = (UIApplication.shared.delegate as? AppDelegate)?.dependency.localizationManager else {
                return NSLocalizedString(self, comment: "")
            }
            return localizationManager.localizedString(for: self)
        } else {
            // Если вызван из фонового потока, делаем синхронный вызов на главном потоке
            var result = NSLocalizedString(self, comment: "")
            let semaphore = DispatchSemaphore(value: 0)
            
            DispatchQueue.main.async {
                guard let localizationManager = (UIApplication.shared.delegate as? AppDelegate)?.dependency.localizationManager else {
                    semaphore.signal()
                    return
                }
                result = localizationManager.localizedString(for: self)
                semaphore.signal()
            }
            
            semaphore.wait()
            return result
        }
    }
    
    /// Статический метод для локализации
    static func localized(_ key: String) -> String {
        return key.localized()
    }
}
