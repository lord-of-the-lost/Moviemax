//
//  ForgotPassPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

protocol ForgotPassPresenterProtocol {
    func setupView(_ view: ForgotPassViewControllerProtocol)
    func backButtonTapped()
    func submitButtonAction()
}

final class ForgotPassPresenter {
    private weak var view: ForgotPassViewControllerProtocol?
    private let router: ForgotPassRouter
    private let authService: AuthenticationService

    init(router: ForgotPassRouter, dependency: DI) {
        self.router = router
        self.authService = dependency.authService
    }
}

// MARK: - ForgotPassPresenterProtocol
extension ForgotPassPresenter: ForgotPassPresenterProtocol {
    func setupView(_ view: ForgotPassViewControllerProtocol) {
        self.view = view
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
            view.showAlert(title: TextConstants.ForgotPass.noUserTitle.localized(), message: nil)
            return
        }
        
        view.showAlert(title: TextConstants.ForgotPass.email.localized() + ": " + email, message: TextConstants.ForgotPass.pass.localized() + ": " + user.password)
    }
}
