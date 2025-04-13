//
//  FilterPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

final class FilterPresenter {
    weak var view: FilterViewController?
    private let router: FilterRouter
    private let dependency: DI
    
    let genres: [String] =
    [
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
    
    init(router: FilterRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
}
