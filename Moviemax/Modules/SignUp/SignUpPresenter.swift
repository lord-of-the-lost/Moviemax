//
//  SignUpPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

import Foundation

final class SignUpPresenter {
    weak var view: SignUpViewController?
    private let router: SignUpRouter
    private let authService: AuthenticationService
    
    init(router: SignUpRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func singUpTapped() {
        guard
            let view,
            let firstName = view.getFirstName(),
            let lastName = view.getLastName(),
            let email = view.getEmail(),
            let password = view.getPassword(),
            let confirmedPassword = view.getConfirmedPassword() else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.emptyFieldsError)
            return
        }
        
        // Проверка совпадения паролей
        guard password == confirmedPassword else {
            view.showAlert(title: Constants.errorTitle, message: Constants.passwordsNotMatchError)
            return
        }
        
        // Проверка валидности email
        guard isValidEmail(email) else {
            view.showAlert(title: Constants.errorTitle, message: Constants.invalidEmailError)
            return
        }
        
        // Создание нового пользователя
        let newUser = User(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            avatar: nil,
            email: email,
            password: password,
            birthDate: "",
            gender: .male,
            notes: nil,
            recentWatch: [],
            favorites: [],
            isOnboardingCompleted: false
        )
        
        // Регистрация пользователя
        let result = authService.register(user: newUser)
        
        switch result {
        case .success:
            router.navigateToMain()
        case .failure(.emailAlreadyExists):
            view.showAlert(title: Constants.errorTitle, message: Constants.emailExistsError)
        case .failure:
            view.showAlert(title: Constants.errorTitle, message: Constants.registerError)
        }
    }
    
    func loginTapped() {
        router.showAuthFlow()
    }
    
    // Вспомогательная функция для валидации email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Constants
private extension SignUpPresenter {
    enum Constants {
        static let errorTitle = "Ошибка"
        static let emptyFieldsError = "Пожалуйста, заполните все поля"
        static let passwordsNotMatchError = "Пароли не совпадают"
        static let invalidEmailError = "Введите корректный email"
        static let emailExistsError = "Пользователь с таким email уже существует"
        static let registerError = "Произошла ошибка при регистрации"
    }
}
