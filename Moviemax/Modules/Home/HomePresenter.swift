//
//  HomePresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import Foundation

final class HomePresenter {
    // MARK: - Properties
    weak var view: HomeViewController?
    private let router: HomeRouter
  
    init(router: HomeRouter) {
        self.router = router
    }
    
    func viewDidLoad() {
        
    }

}

