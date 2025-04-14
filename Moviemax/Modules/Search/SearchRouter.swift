//
//  SearchRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

final class SearchRouter: RouterProtocol {
    weak var viewController: SearchViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToFilter() {
        let filterViewController = FilterFactory.build(dependency)
        filterViewController.modalPresentationStyle = .overFullScreen
        filterViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(filterViewController, animated: true)
    }
    
    func showMovieDetails(movie: Movie) {
        let detailsVC = MovieDetailFactory.build(model: movie, dependency: dependency)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
