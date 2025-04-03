//
//  ProfilePresenter.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

final class ProfilePresenter {
    weak var view: ProfileViewController?
    
    private let router: ProfileRouter
    
    init(router: ProfileRouter, dependency: DI) {
        self.router = router
    }
    
}
