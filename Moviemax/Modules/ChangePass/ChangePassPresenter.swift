//
//  ChangePassPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

final class ChangePassPresenter {
    weak var view: ChangePassViewController?
    private let router: ChangePassRouter
    private let authService: AuthenticationService

    init(router: ChangePassRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
    
    func backButtonTapped() {
        router.navigateToBack()
    }
    
    func changePassButtonAction() {
        print(#function)
        guard
            let view,
            let pass = view.getPass(),
            let confirmPass = view.getConfirmPass(),
            let newPass = view.getNewPass(),
            pass.count + confirmPass.count + newPass.count > 0
        else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.emptyFieldsError)
            return
        }
        
        if pass == confirmPass && pass != newPass {
            let result = authService.changePass(newPass: newPass)
            result ? view.showAlert(title: Constants.success) : view.showAlert(title: Constants.errorTitle)
        } else if pass == confirmPass && pass == newPass {
            view.showAlert(title: Constants.passMatch)
        } else {
            view.showAlert(title: Constants.notMatch)
        }
        
    }
}

// MARK: - Constants
private extension ChangePassPresenter {
    enum Constants {
        static let noUserTitle = "Пользователь не найден"
        static let errorTitle = "Ошибка"
        static let emptyFieldsError = "Пожалуйста, заполните все поля"
        static let success = "Пароль успешно изменён"
        static let notMatch = "Пароли не совпадают"
        static let passMatch = "Новый пароль должен отличаться от старого. Пожалуйста, придумайте другой пароль."

    }
}
