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
        static let saveButtonTitle = "saveButtonTitle"
        static let screenName = "screenName"
        static let firstNameLabel = "firstName"
        static let lastNameLabel = "lastName"
        static let emailLabel = "email"
        static let dateOfBirthLabel = "dateOfBirth"
        static let locationLabel = "location"
        static let errorTitle = "errorTitle"
        static let errorEmptyFields = "errorEmptyFields"
        static let doneButtonTitle = "doneButtonTitle"
        static let cancelButtonTitle = "cancelButtonTitle"
    }
    
    enum RecentWatch {
        static let screenTitle = "screenTitle"
        static let emptyStateTitle = "emptyStateTitle"
        static let emptyStateDescription = "emptyStateDescription"
    }
    
    enum Onboarding {
        enum FirstPage {
            static let largeTitle = "firstPageTitle"
            static let description = "firstPageDescription"
            static let buttonTitle = "continue"
        }
        
        enum SecontPage {
            static let largeTitle = "secondPageTitle"
            static let description = "secondPageDescription"
            static let buttonTitle = "continue"
        }
        
        enum ThirdPage {
            static let largeTitle = "thirdPageTitle"
            static let description = "thirdPageDescription"
            static let buttonTitle = "start"
        }
    }
}
