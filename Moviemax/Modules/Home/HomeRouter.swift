//
//  HomeRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import UIKit

final class HomeRouter: RouterProtocol {
    weak var viewController: UIViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    // MARK: - HomeRouterProtocol
    func showMovieDetails(movie: Movie) {
        let detailsVC = MovieDetailFactory.build(model: movie, dependency: dependency)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func showBoxOfficeMovies() {
     
    }
}

