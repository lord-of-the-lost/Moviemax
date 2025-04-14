//
//  SignUpViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

import UIKit

final class SignUpViewController: BaseScrollViewController {
    private let presenter: SignUpPresenter
    private lazy var firstNameField = TitledTextField()
    private lazy var lastNameField = TitledTextField()
    private lazy var emailField = TitledTextField()
    private lazy var passwordField = TitledTextField(isSecure: true)
    private lazy var confirmPasswordField = TitledTextField(isSecure: true)
    
    private lazy var signUpButton: CommonButton = {
        let button = CommonButton(title: TextConstants.SignUp.singUpButtonTitle.localized())
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.SignUp.accountLabel.localized()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextConstants.SignUp.loginButtonTitle.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init(presenter: SignUpPresenter) {
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
        setupView()
        setupConstraints()
        configureTextFields()
    }
    
    // MARK: - Public Methods
    func getFirstName() -> String? {
        firstNameField.getText()
    }
    
    func getLastName() -> String? {
        lastNameField.getText()
    }
    
    func getEmail() -> String? {
        emailField.getText()
    }
    
    func getPassword() -> String? {
        passwordField.getText()
    }
    
    func getConfirmedPassword() -> String? {
        confirmPasswordField.getText()
    }
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setupView() {
        navigationItem.title = TextConstants.SignUp.screenTitle.localized()
        view.backgroundColor = .appBackground
        contentView.addSubviews(formStackView, signUpButton, loginStackView)
        loginStackView.addArrangedSubviews(accountLabel, loginButton)
        formStackView.addArrangedSubviews(
            firstNameField,
            lastNameField,
            emailField,
            passwordField,
            confirmPasswordField
        )
    }
    
    func setupConstraints() {
        formStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(100)
            $0.leading.trailing.equalTo(contentView).inset(30)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(formStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(contentView).inset(30)
            $0.height.equalTo(50)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(signUpButton.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(40)
        }
    }
    
    func configureTextFields() {
        typealias ViewModel = TitledTextField.TextFieldViewModel
        
        firstNameField.configure(
            with: ViewModel(
                title: TextConstants.SignUp.FirstName.title.localized(),
                placeholder: TextConstants.SignUp.FirstName.placeholder.localized(),
                type: .regular
            )
        )
        
        lastNameField.configure(
            with: ViewModel(
                title: TextConstants.SignUp.LastName.title.localized(),
                placeholder: TextConstants.SignUp.LastName.placeholder.localized(),
                type: .regular
            )
        )
        
        emailField.configure(
            with: ViewModel(
                title: TextConstants.SignUp.Email.title.localized(),
                placeholder: TextConstants.SignUp.Email.placeholder.localized(),
                type: .email
            )
        )
        
        passwordField.configure(
            with: ViewModel(
                title: TextConstants.SignUp.Password.title.localized(),
                placeholder: TextConstants.SignUp.Password.placeholder.localized(),
                type: .password
            )
        )
        
        confirmPasswordField.configure(
            with: ViewModel(
                title: TextConstants.SignUp.ConfirmPassword.title.localized(),
                placeholder:TextConstants.SignUp.ConfirmPassword.placeholder.localized(),
                type: .password
            )
        )
    }
    
    @objc func signUpButtonTapped() {
        presenter.singUpTapped()
    }
    
    @objc func loginButtonTapped() {
        presenter.loginTapped()
    }
}
