//
//  AuthViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    let presenter: AuthPresenter
    
    private lazy var loginButton: CommonButton = {
        let button = CommonButton(title: Constants.Text.buttonTitle)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    init(presenter: AuthPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension AuthViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(loginButton)
    }
    
    func setupConstraints() {
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Constants.Constraints.buttonWidth)
            $0.height.equalTo(Constants.Constraints.buttonHeight)
        }
    }
    
    @objc func loginButtonTapped() {
        presenter.loginButtonTapped()
    }
}

// MARK: - Constants
private extension AuthViewController {
    enum Constants {
        enum Text {
            static let buttonTitle: String = "Авторизоваться"
        }
       
        enum Constraints {
            static let buttonWidth: CGFloat = 200
            static let buttonHeight: CGFloat = 50
        }
    }
}
