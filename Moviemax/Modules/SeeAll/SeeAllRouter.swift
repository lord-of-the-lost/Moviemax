//
//  SeeAllRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

final class SeeAllRouter: RouterProtocol {
    weak var viewController: SeeAllViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func showMovieDetails(_ movie: Movie) {
        let detailsVC = MovieDetailFactory.build(model: movie, dependency: dependency)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func navigateToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
