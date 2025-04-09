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
        print(#function)
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
            view?.showAlert(title: Constants.errorTitle, message: Constants.emptyFieldsError)
            return
        }
        
        // Проверка валидности email
        guard isValidEmail(email) else {
            view.showAlert(title: Constants.errorTitle, message: Constants.invalidEmailError)
            return
        }
        
        // Авторизация пользователя
        let result = authService.login(email: email, password: password)
        
        switch result {
        case .success:
            router.navigateToMain()
        case .failure(.userNotFound):
            view.showAlert(title: Constants.errorTitle, message: Constants.userNotFoundError)
        case .failure(.invalidPassword):
            view.showAlert(title: Constants.errorTitle, message: Constants.invalidPasswordError)
        case .failure:
            view.showAlert(title: Constants.errorTitle, message: Constants.loginError)
        }
    }
    
    // Вспомогательная функция для валидации email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Constants
private extension AuthPresenter {
    enum Constants {
        static let errorTitle = "Ошибка"
        static let emptyFieldsError = "Пожалуйста, заполните все поля"
        static let invalidEmailError = "Введите корректный email"
        static let userNotFoundError = "Пользователь с таким email не найден"
        static let invalidPasswordError = "Неверный пароль"
        static let loginError = "Произошла ошибка при входе"
    }
}
