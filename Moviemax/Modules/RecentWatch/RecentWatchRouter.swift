//
//  RecentWatchRouter.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//


final class RecentWatchRouter: RouterProtocol {
    weak var viewController: RecentWatchViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    /// Навигация к деталям фильма
    func showMovieDetails(_ movie: Movie) {
        let detailsVC = MovieDetailFactory.build(model: movie, dependency: dependency)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
