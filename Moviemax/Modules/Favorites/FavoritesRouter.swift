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
    
    func showMovieDetails(_ movie: Movie) {
        let detailsVC = MovieDetailFactory.build(model: movie, dependency: dependency)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
