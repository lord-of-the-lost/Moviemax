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
    
    enum Home {
        static let greeting = "greeting"
        static let shortGreeting = "shortGreeting"
        static let status = "status"
        static let seeAllText = "seeAll"
        static let boxOfficeText = "boxOffice"
        static let category = "category"
    }
    
    enum EditPhotoView {
        static let title = "editPhotoTitle"
        static let takeTitle = "takePhotoTitle"
        static let chooseTitle = "choosePhotoTitle"
        static let deleteTitle = "deletePhotoTitle"
    }
    
    enum GenderSelectorView {
        static let labelText = "gender"
    }
    
    enum Gender {
        static let male = "male"
        static let female  = "female"
    }
    
    enum Auth {
        static let screenTitle = "login"
        static let singInButtonTitle = "signIn"
        static let forgotPasswordButtonTitle = "forgotPass"
        static let continueWithGoogleButtonTitle = "continueWithGoogle"
        static let rememberMeLabel = "rememberMe"
        static let dividerLabel = "continueWith"
        static let accountLabel = "dontHaveAccount"
        static let signUpButtonTitle = "signUp"
        
        enum Email {
            static let title = "emailTitle"
            static let placeholder = "enterEmail"
        }
        
        enum Password {
            static let title = "passwordTitle"
            static let placeholder = "enterPasswordTitle"
        }
        
        enum Errors {
            static let errorTitle = "errorTitle"
            static let emptyFieldsError = "emptyFieldsError"
            static let invalidEmailError = "invalidEmailError"
            static let userNotFoundError = "userNotFoundError"
            static let invalidPasswordError = "invalidPasswordError"
            static let loginError = "loginError"
        }
    }
    
    enum ChangePass {
        static let screenTitle = "changePassTitle"
        static let changePassButtonTitle = "changePassTitle"
        static let passTitle = "passTitle"
        static let passPlaceholder = "passPlaceholder"
        static let newPassTitle = "newPassTitle"
        static let newPassPlaceholder = "newPassPlaceholder"
        static let confirmPassTitle = "confirmPassTitle"
        static let confirmPassPlaceholder = "confirmPassPlaceholder"
        
        enum Errors {
            static let noUserTitle = "noUserTitle"
            static let errorTitle = "errorTitle"
            static let emptyFieldsError = "emptyFieldsError"
            static let success = "successPass"
            static let notMatch = "passNotMatch"
            static let passMatch = "passMatch"
        }
    }
    
    enum Favorites {
        static let screenTitle = "favorites"
        static let emptyStateTitle = "emptyFavoritesTitle"
        static let emptyStateDescription = "emptyFavoritesDescription"
        static let minutes = "minutes"
        
        enum Errors {
            static let cantDownloadFavorites = "cantDownloadFavorites"
            static let cantDeleteFromFavorites = "cantDeleteFromFavorites"
        }
    }
    
    enum MovieDetail {
        static let movieCastTitle = "movieCastTitle"
        static let screenTitle = "moviewDetailScreenTitle"
        static let movieDescriptionTitle = "movieDescriptionTitle"
        static let watchButtonTitle = "watchButtonTitle"
        static let showMoreText = "showMoreText"
    }
    
    enum SeeAll {
        static let screenTitle = "seeAllScreenTitle"
        static let emptyStateTitle = "seeAllEmptyTitle"
        static let emptyStateDescription = "seeAllEmptyDescription"
    }
    
    enum ForgotPass {
        static let screenTitle = "forgotPassword"
        static let submitButtonTitle = "submitButtonTitle"
        static let title = "emailTitle"
        static let placeholder = "enterEmail"
        static let noUserTitle = "noUserTitle"
        static let errorTitle = "error"
        static let emptyFieldsError = "emptyFieldsError"
        static let email = "emailTitle"
        static let pass = "passwordTitle"
    }
    
    enum SignUp {
        static let screenTitle = "signUp"
        static let singUpButtonTitle = "signUp"
        static let accountLabel = "accountLabel"
        static let loginButtonTitle = "login"
        
        enum FirstName {
            static let title = "firstName"
            static let placeholder = "namePlaceholder"
        }
        
        enum LastName {
            static let title = "lastName"
            static let placeholder = "surnamePlaceholder"
        }
        
        enum Email {
            static let title = "email"
            static let placeholder = "enterEmail"
        }
        
        enum Password {
            static let title = "passwordTitle"
            static let placeholder = "enterPasswordTitle"
        }
        
        enum ConfirmPassword {
            static let title = "confirmPassTitle"
            static let placeholder = "enterPasswordTitle"
        }
    }
}
