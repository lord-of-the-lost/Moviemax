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
            view?.showAlert(title: TextConstants.ForgotPass.errorTitle.localized(), message: TextConstants.ForgotPass.emptyFieldsError.localized())
            return
        }
        
        guard
            let user = authService.getUserByEmail(email: email)
        else {
            view.showAlert(title: TextConstants.ForgotPass.noUserTitle.localized())
            return
        }
        
        view.showAlert(title: TextConstants.ForgotPass.email.localized() + ": " + email, message: TextConstants.ForgotPass.pass.localized() + ": " + user.password)
    }
}
