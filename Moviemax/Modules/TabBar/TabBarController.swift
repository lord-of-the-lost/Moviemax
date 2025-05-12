//
//  TabBarController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import UIKit

protocol TabBarControllerProtocol: AnyObject {
    var tabBar: UITabBar { get }
    var selectedIndex: Int { get set }
    
    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool)
}

final class TabBarController: UITabBarController  {
    private let presenter: TabBarPresenterProtocol
    
    init(presenter: TabBarPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 75
        tabBar.frame.origin.y = view.frame.height - 75
    }
}

extension TabBarController: TabBarControllerProtocol {}
