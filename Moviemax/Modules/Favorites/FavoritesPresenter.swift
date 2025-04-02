//
//  FavoritesPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

final class FavoritesPresenter {
    weak var view: FavoritesViewController?
    private let router: FavoritesRouter
    
    var state: FavoritesState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    init(router: FavoritesRouter, dependency: DI) {
        self.router = router
    }
    
    func viewDidLoad() {
        state = .content(MovieLargeCell.mockData)
    }
    
    func didSelectMovie(at index: Int) {
        print(#function)
       // router.showMovieDetails(movie)
    }
    
    func likeButtonTapped(at index: Int) {
        print(#function)
    }
}

