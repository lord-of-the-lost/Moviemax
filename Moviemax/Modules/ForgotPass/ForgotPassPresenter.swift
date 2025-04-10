//
//  ForgotPassPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

final class ForgotPassPresenter {
    weak var view: ForgotPassViewController?
    private let router: ForgotPassRouter
    
    init(router: ForgotPassRouter, dependency: DI) {
        self.router = router
    }
    
    func backButtonTapped() {
        router.navigateToBack()
    }
}
