//
//  TabBarController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import UIKit

final class TabBarController: UITabBarController  {
    let presenter: TabBarPresenter
    
    init(presenter: TabBarPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 75
        tabBar.frame.origin.y = view.frame.height - 75
    }
}
