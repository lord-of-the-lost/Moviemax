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
        let button = CommonButton(title: Constants.Text.singUpButtonTitle)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.accountLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Text.loginButtonTitle, for: .normal)
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
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setupView() {
        navigationItem.title = Constants.Text.screenTitle
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
                title: Constants.Text.FirstName.title,
                placeholder: Constants.Text.FirstName.placeholder,
                type: .regular
            )
        )
        
        lastNameField.configure(
            with: ViewModel(
                title: Constants.Text.LastName.title,
                placeholder: Constants.Text.LastName.placeholder,
                type: .regular
            )
        )
        
        emailField.configure(
            with: ViewModel(
                title: Constants.Text.Email.title,
                placeholder: Constants.Text.Email.placeholder,
                type: .email
            )
        )
        
        passwordField.configure(
            with: ViewModel(
                title: Constants.Text.Password.title,
                placeholder: Constants.Text.Password.placeholder,
                type: .password
            )
        )
        
        confirmPasswordField.configure(
            with: ViewModel(
                title: Constants.Text.ConfirmPassword.title,
                placeholder: Constants.Text.ConfirmPassword.placeholder,
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

// MARK: - Constants
private extension SignUpViewController {
    enum Constants {
        enum Text {
            static let screenTitle = "Sign Up"
            static let singUpButtonTitle = "Sign Up"
            static let accountLabel = "Already have an account?"
            static let loginButtonTitle = "Login"
            
            enum FirstName {
                static let title = "First Name"
                static let placeholder = "Enter your name"
            }
            
            enum LastName {
                static let title = "Last Name"
                static let placeholder = "Enter your name"
            }
            
            enum Email {
                static let title = "E-mail"
                static let placeholder = "Enter your email address"
            }
            
            enum Password {
                static let title = "Password"
                static let placeholder = "Enter your password"
            }
            
            enum ConfirmPassword {
                static let title = "Confirm Password"
                static let placeholder = "Enter your password"
            }
        }
    }
}
