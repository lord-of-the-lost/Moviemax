//
//  ChangePassPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

protocol ChangePassPresenterProtocol {
    func setupView(_ view: ChangePassViewControllerProtocol)
    func backButtonTapped()
    func changePassButtonAction()
}

final class ChangePassPresenter {
    weak var view: ChangePassViewControllerProtocol?
    private let router: ChangePassRouter
    private let authService: AuthenticationService

    init(router: ChangePassRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
}

// MARK: - ChangePassPresenterProtocol
extension ChangePassPresenter: ChangePassPresenterProtocol {
    func setupView(_ view: ChangePassViewControllerProtocol) {
        self.view = view
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
            view.showAlert(title: TextConstants.ChangePass.Errors.noUserTitle.localized(), message: nil)
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
            view.showAlert(title: TextConstants.ChangePass.Errors.notMatch.localized(), message: nil)
            return
        }
        
        // Проверяем, что новый пароль отличается от текущего
        if currentPass == newPass {
            view.showAlert(title: TextConstants.ChangePass.Errors.passMatch.localized(), message: nil)
            return
        }
        
        // Обновляем пароль
        let result = authService.changePass(newPass: newPass)
        if result {
            view.showAlert(title: TextConstants.ChangePass.Errors.success.localized(), message: nil)
        } else {
            view.showAlert(title: TextConstants.ChangePass.Errors.errorTitle.localized(), message: nil)
        }
    }
}
