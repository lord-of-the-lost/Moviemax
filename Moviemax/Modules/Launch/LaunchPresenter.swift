//
//  LaunchPresenter.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

final class LaunchPresenter {
    
    weak var view: LaunchViewController?
    private let router: LaunchRouter
    private let dependency: DI
    
    init(router: LaunchRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
    
    func viewDidFinishAnimate() {
        router.navigateToTabbar()
    }
}
