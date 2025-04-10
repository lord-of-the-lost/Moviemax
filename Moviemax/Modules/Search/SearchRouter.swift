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
}
