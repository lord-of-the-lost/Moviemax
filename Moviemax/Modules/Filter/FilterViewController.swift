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
    
    private lazy var filetView = FilterView()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.7
        return view
    }()
    
    // MARK: Init
    init(presenter: FilterPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
}

// MARK: - Private methods
private extension FilterViewController {
    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(blurView)
        view.addSubview(filetView)
        
        filetView.closeButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func setupConstraints() {
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filetView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
