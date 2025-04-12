//
//  ForgotPassPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

final class ForgotPassPresenter {
    weak var view: ForgotPassViewController?
    private let router: ForgotPassRouter
    private let authService: AuthenticationService

    init(router: ForgotPassRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func backButtonTapped() {
        router.navigateToBack()
    }
    
    func submitButtonAction() {
        guard
            let view,
            let email = view.getEmail(),
            email.count > 0
        else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.emptyFieldsError)
            return
        }
        
        guard
            let user = authService.getUserByEmail(email: email)
        else {
            view.showAlert(title: Constants.noUserTitle)
            return
        }
        
        view.showAlert(title: Constants.email + ": " + email, message: Constants.pass + ": " + user.password)
    }
}

// MARK: - Constants
private extension ForgotPassPresenter {
    enum Constants {
        static let noUserTitle = "Пользователь не найден"
        static let errorTitle = "Ошибка"
        static let emptyFieldsError = "Пожалуйста, заполните все поля"
        static let email = "Email"
        static let pass = "Пароль"
    }
}
