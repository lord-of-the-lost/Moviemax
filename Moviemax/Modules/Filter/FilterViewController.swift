//
//  FilterViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: Properties
    private let presenter: FilterPresenter
    
    // MARK: Init
    init(presenter: FilterPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private methods
private extension FilterViewController {
    func setupUI() {
        view.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    func setupConstraints() {
        
    }
}

// MARK: - Constants
private extension FilterViewController {
    enum Constants {
        enum Text {
            static let screenTitle = "Search"
            static let emptyStateTitle = "You haven't seen any movies yet."
            static let emptyStateDescription = "Movies that you have watched recently will appear here."
        }
    }
}
