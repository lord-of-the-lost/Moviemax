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
    
    let genres: [String] =  ["All", "Action", "Adventure", "Animation", "Biography", "Comedy", "Drama", "Fantasy", "History", "Horror", "Music", "Romance", "Science Fiction", "Thriller", "War", "Western"]
    
    init(router: FilterRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
}
