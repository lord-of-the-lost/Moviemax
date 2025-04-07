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
    private lazy var contentView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureTextFields()
        setupKeyboardObservers()
        addTapGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setupView() {
        navigationItem.title = Constants.Text.screenTitle
        view.backgroundColor = .appBackground
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
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
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
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
            $0.top.equalTo(signUpButton.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(40)
        }
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight: CGFloat = keyboardFrame.height
        let baseOffset: CGFloat = 30
        let resultOffset: CGFloat = keyboardHeight + baseOffset
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: resultOffset, right: 0)
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            // Если есть активное текстовое поле, прокручиваем к нему
            if let activeField = self.view.findFirstResponder() as? UITextField {
                let activeRect = activeField.convert(activeField.bounds, to: self.scrollView)
                let visibleRect = self.scrollView.bounds.inset(by: contentInsets)
                
                if !visibleRect.contains(activeRect) {
                    self.scrollView.scrollRectToVisible(activeRect, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func signUpButtonTapped() {
        print("Sign Up button tapped")

    }
    
    @objc func loginButtonTapped() {
        print("Login button tapped")
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
                static let placeholder = "Enter your email"
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
