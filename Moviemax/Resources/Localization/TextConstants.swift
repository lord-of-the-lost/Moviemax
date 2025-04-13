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
    
    enum Profile {
        static let saveButtonTitle: String = "saveButtonTitle"
        static let screenName: String = "screenName"
        static let firstNameLabel: String = "firstName"
        static let lastNameLabel: String = "lastName"
        static let emailLabel: String = "email"
        static let dateOfBirthLabel: String = "dateOfBirth"
        static let locationLabel: String = "location"
        static let errorTitle: String = "errorTitle"
        static let errorEmptyFields: String = "errorEmptyFields"
        static let doneButtonTitle: String = "doneButtonTitle"
        static let cancelButtonTitle: String = "cancelButtonTitle"
    }
}
