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
    private var model: Movie
    
    init(router: MovieDetailRouter, dependency: DI, model: Movie) {
        self.router = router
        self.model = model
    }
    
    func backButtonTapped() {
        router.closeMovieDetailScreen()
    }
}
