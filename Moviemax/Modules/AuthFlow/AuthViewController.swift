//
//  AuthViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class AuthViewController: BaseScrollViewController {
    private let presenter: AuthPresenter
    private lazy var emailField = TitledTextField()
    private lazy var passwordField = TitledTextField(isSecure: true)
    
    private lazy var signInButton: CommonButton = {
        let button = CommonButton(title: TextConstants.Auth.singInButtonTitle.localized())
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var rememberMeCheckbox: UISwitch = {
        let checkbox = UISwitch()
        checkbox.onTintColor = UIColor(resource: .accent)
        return checkbox
    }()
    
    private lazy var rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Auth.rememberMeLabel.localized()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var rememberMeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextConstants.Auth.forgotPasswordButtonTitle.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var passwordOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var dividerLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Auth.dividerLabel.localized()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextConstants.Auth.continueWithGoogleButtonTitle.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.adaptiveTextMain, for: .normal)
        
        let googleIcon = UIImage(resource: .google).withRenderingMode(.alwaysOriginal)
        button.setImage(googleIcon, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        button.configuration = configuration
        
        button.backgroundColor = .appBackground
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        
        button.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Auth.accountLabel.localized()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextConstants.Auth.signUpButtonTitle.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpStackView: UIStackView = {
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
    
    init(presenter: AuthPresenter) {
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
    func getEmail() -> String? {
        emailField.getText()
    }
    
    func getPassword() -> String? {
        passwordField.getText()
    }
    
    func isRememberMeChecked() -> Bool {
        rememberMeCheckbox.isOn
    }
}

// MARK: - Private Methods
private extension AuthViewController {
    func setupView() {
        navigationItem.title = TextConstants.Auth.screenTitle.localized()
        view.backgroundColor = .appBackground
        setScrollState(isScrollEnabled: false)
        
        contentView.addSubviews(
            formStackView,
            passwordOptionsStackView,
            signInButton,
            dividerLabel,
            googleButton,
            signUpStackView
        )
        
        rememberMeStackView.addArrangedSubviews(rememberMeCheckbox, rememberMeLabel)
        passwordOptionsStackView.addArrangedSubviews(rememberMeStackView, forgotPasswordButton)
        signUpStackView.addArrangedSubviews(accountLabel, signUpButton)
        formStackView.addArrangedSubviews(emailField, passwordField)
    }
    
    func setupConstraints() {
        formStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(100)
            $0.leading.trailing.equalTo(contentView).inset(30)
        }
        
        passwordOptionsStackView.snp.makeConstraints {
            $0.top.equalTo(formStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(30)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordOptionsStackView.snp.bottom).offset(65)
            $0.leading.trailing.equalTo(contentView).inset(30)
            $0.height.equalTo(50)
        }
        
        dividerLabel.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(12)
            $0.height.equalTo(22)
            $0.leading.trailing.equalTo(contentView).inset(30)
        }
        
        googleButton.snp.makeConstraints {
            $0.top.equalTo(dividerLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(30)
            $0.height.equalTo(50)
        }
        
        signUpStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(googleButton.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).inset(40)
        }
    }
    
    func configureTextFields() {
        typealias ViewModel = TitledTextField.TextFieldViewModel
        
        emailField.configure(
            with: ViewModel(
                title: TextConstants.Auth.Email.title.localized(),
                placeholder: TextConstants.Auth.Email.placeholder.localized(),
                type: .email
            )
        )
        
        passwordField.configure(
            with: ViewModel(
                title: TextConstants.Auth.Password.title.localized(),
                placeholder: TextConstants.Auth.Password.placeholder.localized(),
                type: .password
            )
        )
    }
    
    @objc func forgotPasswordTapped() {
        presenter.forgotPasswordTapped()
    }
    
    @objc func googleSignInTapped() {
        presenter.googleSignInTapped()
    }
    
    @objc func signInButtonTapped() {
        presenter.signInTapped()
    }
    
    @objc func signUpButtonTapped() {
        presenter.signUpTapped()
    }
}
