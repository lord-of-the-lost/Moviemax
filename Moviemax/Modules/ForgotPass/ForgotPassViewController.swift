//
//  ForgotPassViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit
import SnapKit

final class ForgotPassViewController: UIViewController {
    private let presenter: ForgotPassPresenter
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .arrowBack), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: CommonButton = {
        let button = CommonButton(title: TextConstants.ForgotPass.submitButtonTitle.localized())
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailField = TitledTextField()
    
    init(presenter: ForgotPassPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        setupConstraints()
        setupNavigation()
        configureTextFields()
    }
    
    // MARK: - Public Methods
    func getEmail() -> String? {
        emailField.getText()
    }
}

// MARK: - Private Methods
private extension ForgotPassViewController {
    func setupUI() {
        navigationItem.title = TextConstants.ForgotPass.screenTitle.localized()
        view.backgroundColor = .appBackground
        view.addSubviews(emailField, submitButton)
    }
    
    func setupConstraints() {
        emailField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
    }
    
    func setupNavigation() {
        self.title = TextConstants.ForgotPass.screenTitle.localized()
                
        backButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: AppFont.montserratBold.withSize(18),
            .foregroundColor: UIColor.adaptiveTextMain
        ]
    }
    
    func configureTextFields() {
        typealias ViewModel = TitledTextField.TextFieldViewModel
        
        emailField.configure(
            with: ViewModel(
                title: TextConstants.ForgotPass.title.localized(),
                placeholder: TextConstants.ForgotPass.placeholder.localized(),
                type: .regular
            )
        )
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    @objc func submitButtonTapped() {
        presenter.submitButtonAction()
    }
}
