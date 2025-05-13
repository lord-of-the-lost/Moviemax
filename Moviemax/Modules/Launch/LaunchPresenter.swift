//
//  LaunchPresenter.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

protocol LaunchPresenterProtocol {
    func setupView(_ view: LaunchViewControllerProtocol)
    func viewDidFinishAnimate()
}

final class LaunchPresenter {
    private weak var view: LaunchViewControllerProtocol?
    private let router: LaunchRouter
    
    init(router: LaunchRouter) {
        self.router = router
    }
}

// MARK: - LaunchPresenterProtocol
extension LaunchPresenter: LaunchPresenterProtocol {
    func setupView(_ view: LaunchViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidFinishAnimate() {
        router.navigateToTabbar()
    }
}
