//
//  SignUpPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

final class SignUpPresenter {
    weak var view: SignUpViewController?
    private let router: SignUpRouter
    
    init(router: SignUpRouter, dependency: DI) {
        self.router = router
    }
    
    func singUpTapped() {
        router.navigateToMain()
    }
    
    func loginTapped() {
        router.showAuthFlow()
    }
}
