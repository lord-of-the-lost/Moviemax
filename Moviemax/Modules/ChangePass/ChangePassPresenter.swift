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
            let pass = view.getPass(),
            let confirmPass = view.getConfirmPass(),
            let newPass = view.getNewPass(),
            pass.count + confirmPass.count + newPass.count > 0
        else {
            view?.showAlert(title: TextConstants.ChangePass.Errors.errorTitle.localized(), message: TextConstants.ChangePass.Errors.emptyFieldsError.localized())
            return
        }
        
        if newPass == confirmPass && pass != newPass {
            let result = authService.changePass(newPass: newPass)
            result ? view.showAlert(title: TextConstants.ChangePass.Errors.success.localized()) : view.showAlert(title: TextConstants.ChangePass.Errors.errorTitle.localized())
        } else if newPass == confirmPass && pass == newPass {
            view.showAlert(title: TextConstants.ChangePass.Errors.passMatch.localized())
        } else {
            view.showAlert(title: TextConstants.ChangePass.Errors.notMatch.localized())
        }
    }
}
