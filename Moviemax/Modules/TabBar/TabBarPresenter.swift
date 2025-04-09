//
//  TabBarPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class TabBarPresenter {
    weak var view: TabBarController?
    private let router: TabBarRouter
    private let dependency: DI
    
    init(router: TabBarRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
    
    func viewDidLoad() {
        configureTabBar()
    }
}

// MARK: - Private Methods
private extension TabBarPresenter {
    func configureTabBar() {
        guard let view else { return }
        
        view.tabBar.backgroundColor = UIColor(resource: .tabBarBG)
        
        let homeItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .home).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .home).withRenderingMode(.alwaysOriginal)
        )
        homeItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        
        let recentItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .recent),
            selectedImage: UIImage(resource: .recent).withTintColor(UIColor(resource: .accent))
        )
        recentItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let searchItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .search),
            selectedImage: UIImage(resource: .search).withTintColor(UIColor(resource: .accent))
        )
        searchItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let favoritesItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .favorites),
            selectedImage: UIImage(resource: .favorites).withTintColor(UIColor(resource: .accent))
        )
        favoritesItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let settingsItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .profile),
            selectedImage: UIImage(resource: .profile).withTintColor(UIColor(resource: .accent))
        )
        settingsItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let searchViewController = UIViewController()
        let recentViewController = UIViewController()
        let mainViewController = UIViewController()
        let favoritesViewController = FavoritesFactory.build(dependency)
        let settingsViewController = SettingsFactory.build(dependency)
        
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        let recentNavigation = UINavigationController(rootViewController: recentViewController)
        let mainNavigation = UINavigationController(rootViewController: mainViewController)
        let favoritesNavigation = UINavigationController(rootViewController: favoritesViewController)
        let settingsNavigation = UINavigationController(rootViewController: settingsViewController)
        
        searchViewController.tabBarItem = searchItem
        recentNavigation.tabBarItem = recentItem
        mainViewController.tabBarItem = homeItem
        favoritesViewController.tabBarItem = favoritesItem
        settingsViewController.tabBarItem = settingsItem
        
        view.setViewControllers([
            searchNavigation,
            recentNavigation,
            mainNavigation,
            favoritesNavigation,
            settingsNavigation
        ], animated: false)
    }
}
