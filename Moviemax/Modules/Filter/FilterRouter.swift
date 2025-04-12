//
//  FilterRouter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

final class FilterRouter: RouterProtocol {
    weak var viewController: FilterViewController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
}
