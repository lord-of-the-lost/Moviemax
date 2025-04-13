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
        guard
            let view,
            let currentPass = view.getCurrentPassword(),
            let newPass = view.getNewPassword(),
            let confirmNewPass = view.getConfirmNewPassword(),
            currentPass.count > 0 && newPass.count > 0 && confirmNewPass.count > 0
        else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.emptyFieldsError)
            return
        }
        
        guard let currentUser = authService.getCurrentUser() else {
            view.showAlert(title: Constants.noUserTitle)
            return
        }
        
        // Проверяем, что текущий пароль верный
        if currentUser.password != currentPass {
            view.showAlert(title: Constants.errorTitle, message: Constants.invalidCurrentPassword)
            return
        }
        
        // Проверяем, что новый пароль и его подтверждение совпадают
        if newPass != confirmNewPass {
            view.showAlert(title: Constants.notMatch)
            return
        }
        
        // Проверяем, что новый пароль отличается от текущего
        if currentPass == newPass {
            view.showAlert(title: Constants.passMatch)
            return
        }
        
        // Обновляем пароль
        let result = authService.changePass(newPass: newPass)
        if result {
            view.showAlert(title: Constants.success)
        } else {
            view.showAlert(title: Constants.errorTitle)
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
        static let invalidCurrentPassword = "Неверный текущий пароль"
    }
}
