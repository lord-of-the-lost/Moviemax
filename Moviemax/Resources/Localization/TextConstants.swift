//
//  TextConstants.swift
//  Moviemax
//
//  Created by Николай Игнатов on 13.04.2025.
//

import Foundation

/// Глобальные константы приложения
enum TextConstants {
    /// Общие текстовые константы
    enum Common {
        static let ok = "ok"
        static let cancel = "cancel"
        static let error = "error"
        static let success = "success"
    }
    
    /// Константы для модуля Settings
    enum Settings {
        static let screenTitle = "settings"
        static let personalInfo = "personalInfo"
        static let profile = "profile"
        static let securityInfo = "securityInfo"
        static let changePassword = "changePassword"
        static let forgotPassword = "forgotPassword"
        static let darkMode = "darkMode"
        static let useRussian = "useRussian"
        static let logout = "logout"
    }
}
