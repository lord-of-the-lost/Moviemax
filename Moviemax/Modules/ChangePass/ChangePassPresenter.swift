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
            view?.showAlert(title: TextConstants.ChangePass.Errors.errorTitle.localized(), message: TextConstants.ChangePass.Errors.emptyFieldsError.localized())
            return
        }
        
        guard let currentUser = authService.getCurrentUser() else {
            view.showAlert(title: TextConstants.ChangePass.Errors.noUserTitle)
            return
        }
        
        // Проверяем, что текущий пароль верный
        if currentUser.password != currentPass {
            view.showAlert(
                title: TextConstants.ChangePass.Errors.errorTitle.localized(),
                message: TextConstants.ChangePass.Errors.invalidCurrentPassword.localized()
            )
            return
        }
        
        // Проверяем, что новый пароль и его подтверждение совпадают
        if newPass != confirmNewPass {
            view.showAlert(title: TextConstants.ChangePass.Errors.notMatch.localized())
            return
        }
        
        // Проверяем, что новый пароль отличается от текущего
        if currentPass == newPass {
            view.showAlert(title: TextConstants.ChangePass.Errors.passMatch.localized())
            return
        }
        
        // Обновляем пароль
        let result = authService.changePass(newPass: newPass)
        if result {
            view.showAlert(title: TextConstants.ChangePass.Errors.success.localized())
        } else {
            view.showAlert(title: TextConstants.ChangePass.Errors.errorTitle.localized())
        }
    }
}
