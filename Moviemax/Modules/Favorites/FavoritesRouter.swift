//
//  FavoritesRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

final class FavoritesRouter: RouterProtocol {
    weak var viewController: FavoritesViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    /// Навигация к деталям фильма
    func showMovieDetails(_ movie: MovieLargeCell.MovieLargeCellViewModel) {
        // let detailsVC = MovieDetailsFactory.build(movie, dependency)
        // viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
