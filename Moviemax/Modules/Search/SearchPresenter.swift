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
    
    let genres: [String] =  [
        TextConstants.Genres.all.localized(),
        TextConstants.Genres.action.localized(),
        TextConstants.Genres.adventure.localized(),
        TextConstants.Genres.animation.localized(),
        TextConstants.Genres.biography.localized(),
        TextConstants.Genres.drama.localized(),
        TextConstants.Genres.fantasy.localized(),
        TextConstants.Genres.history.localized(),
        TextConstants.Genres.music.localized(),
        TextConstants.Genres.mystery.localized(),
        TextConstants.Genres.romance.localized(),
        TextConstants.Genres.scienceFiction.localized(),
        TextConstants.Genres.thriller.localized(),
        TextConstants.Genres.war.localized(),
        TextConstants.Genres.western.localized(),
    ]
    
    
    
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
        router.navigateToFilter()
    }
}
