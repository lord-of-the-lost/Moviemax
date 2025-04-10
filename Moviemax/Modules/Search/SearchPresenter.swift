//
//  SearchPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

final class SearchPresenter {
    weak var view: SearchViewController?
    private let router: SearchRouter
    private let dependency: DI
    
    
    var state: SearchState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    let genres: [String] =  ["All", "Action", "Adventure", "Animation", "Biography", "Comedy", "Drama", "Fantasy", "History", "Horror", "Music", "Romance", "Science Fiction", "Thriller", "War", "Western"]
    
    
    init(router: SearchRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
    
    func viewDidLoad() {
        state = .content(MovieLargeCell.mockData)
    }
    
    func didSelectMovie(at index: Int) {
        print(#function)
    }
    
    func likeButtonTapped(at index: Int) {
        print(#function)
    }
    
    func filterButtonTapped() {
        print(#function)
    }
}
