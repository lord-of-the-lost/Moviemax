//
//  AuthPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class AuthPresenter {
    weak var view: AuthViewController?
    private let router: AuthRouter
    private let authService: AuthenticationService
    
    init(router: AuthRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func forgotPasswordTapped() {
        router.showForgotPassFlow()
    }
    
    func googleSignInTapped() {
        print(#function)
    }
    
    func signUpTapped() {
        router.showSignUpFlow()
    }
    
    func signInTapped() {
        guard
            let view,
            let email = view.getEmail(),
            let password = view.getPassword()
        else {
            view?.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Auth.Errors.emptyFieldsError.localized()
            )
            return
        }
        
        // Проверка валидности email
        guard isValidEmail(email) else {
            view.showAlert(
                    title: TextConstants.Auth.Errors.errorTitle.localized(),
                    message: TextConstants.Auth.Errors.invalidEmailError.localized()
                )
            return
        }
        
        // Получаем состояние чекбокса "Remember Me"
        let rememberMe = view.isRememberMeChecked()
        
        // Авторизация пользователя
        let result = authService.login(email: email, password: password, rememberMe: rememberMe)
        
        switch result {
        case .success:
            router.navigateToMain()
        case .failure(.userNotFound):
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Auth.Errors.userNotFoundError.localized()
            )
        case .failure(.invalidPassword):
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Auth.Errors.invalidPasswordError.localized()
            )
        case .failure:
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Auth.Errors.loginError.localized()
            )
        }
    }
    
    // Вспомогательная функция для валидации email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
