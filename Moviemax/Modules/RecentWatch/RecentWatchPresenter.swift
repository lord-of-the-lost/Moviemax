//
//  RecentWatchPresenter.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit

final class RecentWatchPresenter {
    weak var view: RecentWatchViewController?
    private let router: RecentWatchRouter
    private let dependency: DI
    
    
    var state: RecentWatchState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    let genres: [String] = ["All", "Action", "Adventure", "Animation", "Biography", "Comedy", "Drama", "Fantasy", "History", "Horror", "Music", "Romance", "Science Fiction", "Thriller", "War", "Western"]
    
    
    init(router: RecentWatchRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
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
