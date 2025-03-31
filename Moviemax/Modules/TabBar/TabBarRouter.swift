//
//  TabBarRouter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//


final class TabBarRouter: RouterProtocol {
    weak var viewController: TabBarController?
    private let dependency: DI
    
    init(dependency: DI) {
        self.dependency = dependency
    }
    
    func navigateToSearch() {
        viewController?.selectedIndex = 0
    }
    
    func navigateToRecent() {
        viewController?.selectedIndex = 1
    }
    
    func navigateToMain() {
        viewController?.selectedIndex = 2
    }
    
    func navigateToFavorites() {
        viewController?.selectedIndex = 3
    }
    
    func navigateToProfile() {
        viewController?.selectedIndex = 4
    }
}
