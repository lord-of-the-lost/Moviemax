//
//  TabBarController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 75
        tabBar.frame.origin.y = view.frame.height - 75
    }
}

// MARK: - Private Methods
private extension TabBarController {
    func configureTabBar() {
        tabBar.backgroundColor = UIColor(resource: .tabBarBG)
        
        let homeItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .home).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .home).withRenderingMode(.alwaysOriginal)
        )
        homeItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        
        let recentItem =  UITabBarItem(
            title: nil,
            image: UIImage(resource: .recent),
            selectedImage: UIImage(resource: .recent).withTintColor(UIColor(resource: .accent))
        )
        recentItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let searchItem =  UITabBarItem(
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
        
        let profileItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .profile),
            selectedImage: UIImage(resource: .profile).withTintColor(UIColor(resource: .accent))
        )
        profileItem.imageInsets = UIEdgeInsets(top: 19, left: 0, bottom: -19, right: 0)
        
        let searchViewController = UIViewController()
        let recentViewController = UIViewController()
        let mainViewController = UIViewController()
        let favoritesViewController = UIViewController()
        let profileViewController = UIViewController()
        
        let searchNavigation = UINavigationController(rootViewController: searchViewController)
        let recentNavigation = UINavigationController(rootViewController: recentViewController)
        let mainNavigation = UINavigationController(rootViewController: mainViewController)
        let favoritesNavigation = UINavigationController(rootViewController: favoritesViewController)
        let profileNavigation = UINavigationController(rootViewController: profileViewController)
        
        searchViewController.tabBarItem = searchItem
        recentNavigation.tabBarItem = recentItem
        mainViewController.tabBarItem = homeItem
        favoritesViewController.tabBarItem = favoritesItem
        profileViewController.tabBarItem = profileItem
        
        setViewControllers([
            searchNavigation,
            recentNavigation,
            mainNavigation,
            favoritesNavigation,
            profileNavigation
        ], animated: true)
    }
}
