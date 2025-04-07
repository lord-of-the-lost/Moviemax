//
//  SingUpViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    
    private lazy var firstNameField = TitledTextField()
    private lazy var lastNameField = TitledTextField()
    private lazy var emailField = TitledTextField()
    private lazy var passwordField = TitledTextField(isSecure: true)
    private lazy var confirmPasswordField = TitledTextField(isSecure: true)
    
    private lazy var signUpButton: CommonButton = {
        let button = CommonButton(title: "Sign Up")
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureTextFields()
    }
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setupView() {
        view.backgroundColor = .appBackground
        view.addSubviews(formStackView, signUpButton, loginStackView)
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
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(formStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    func configureTextFields() {
        typealias ViewModel = TitledTextField.TextFieldViewModel
        
        firstNameField.configure(
            with: ViewModel(
                title: "First Name",
                placeholder: "Enter your name",
                type: .regular
            )
        )
        
        lastNameField.configure(
            with: ViewModel(
                title: "Last Name",
                placeholder: "Enter your name",
                type: .regular
            )
        )
        
        emailField.configure(
            with: ViewModel(
                title: "E-mail",
                placeholder: "Enter your email",
                type: .email
            )
        )
        
        passwordField.configure(
            with: ViewModel(
                title: "Password",
                placeholder: "Enter your password",
                type: .password
            )
        )
        
        confirmPasswordField.configure(
            with: ViewModel(
                title: "Confirm Password",
                placeholder: "Enter your password",
                type: .password
            )
        )
    }
    
    @objc func signUpButtonTapped() {
        print("Sign Up button tapped")

    }
    
    @objc func loginButtonTapped() {
        print("Login button tapped")
    }
}
