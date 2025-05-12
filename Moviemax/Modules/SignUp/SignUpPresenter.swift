//
//  SignUpPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

import Foundation

protocol SignUpPresenterProtocol {
    func setupView(_ view: SignUpViewControllerProtocol)
    func loginTapped()
    func singUpTapped()
}

final class SignUpPresenter {
    weak var view: SignUpViewControllerProtocol?
    private let router: SignUpRouter
    private let authService: AuthenticationService
    
    init(router: SignUpRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
}

// MARK: - SignUpPresenterProtocol
extension SignUpPresenter: SignUpPresenterProtocol {
    func setupView(_ view: SignUpViewControllerProtocol) {
        self.view = view
    }
    
    func loginTapped() {
        router.showAuthFlow()
    }
    
    func singUpTapped() {
        guard
            let view,
            let firstName = view.getFirstName(),
            let lastName = view.getLastName(),
            let email = view.getEmail(),
            let password = view.getPassword(),
            let confirmedPassword = view.getConfirmedPassword() else {
            view?.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Auth.Errors.emptyFieldsError.localized()
            )
            return
        }
        
        // Проверка совпадения паролей
        guard password == confirmedPassword else {
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.ChangePass.Errors.notMatch.localized()
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
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.SignUp.emailExistsError.localized()
            )
        case .failure:
            view.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.SignUp.registerError.localized()
            )
        }
    }
}

// MARK: - Private Methods
private extension SignUpPresenter {
    /// Вспомогательная функция для валидации email
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
