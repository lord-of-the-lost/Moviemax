//
//  MovieDetailPresenter.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit

final class MovieDetailPresenter {
    weak var view: MovieDetailViewController?
    private let router: MovieDetailRouter
    
    init(router: MovieDetailRouter, dependency: DI) {
        self.router = router
    }
}
