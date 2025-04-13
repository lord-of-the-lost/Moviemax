//
//  ChangePassViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

import UIKit
import SnapKit

final class ChangePassViewController: UIViewController {
    private let presenter: ChangePassPresenter
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .arrowBack), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePassButton: CommonButton = {
        let button = CommonButton(title: TextConstants.ChangePass.changePassButtonTitle.localized())
        button.addTarget(self, action: #selector(changePassButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var passField = TitledTextField()
    private lazy var confirmPassField = TitledTextField()
    private lazy var newPassField = TitledTextField()

    
    init(presenter: ChangePassPresenter) {
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
    func getPass() -> String? {
        passField.getText()
    }
    
    func getConfirmPass() -> String? {
        confirmPassField.getText()
    }
    
    func getNewPass() -> String? {
        newPassField.getText()
    }
}

// MARK: - Private Methods
private extension ChangePassViewController {
    func setupUI() {
        navigationItem.title = TextConstants.ChangePass.screenTitle.localized()
        view.backgroundColor = .appBackground
        view.addSubviews(passField, confirmPassField, newPassField, changePassButton)
    }
    
    func setupConstraints() {
        passField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        newPassField.snp.makeConstraints {
            $0.top.equalTo(passField.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        confirmPassField.snp.makeConstraints {
            $0.top.equalTo(newPassField.snp.bottom).inset(-16)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        changePassButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
    }
    
    func setupNavigation() {
        self.title = TextConstants.ChangePass.screenTitle.localized()
                
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
        
        passField.configure(
            with: ViewModel(
                title: TextConstants.ChangePass.passTitle.localized(),
                placeholder: TextConstants.ChangePass.passPlaceholder.localized(),
                type: .password
            )
        )

        newPassField.configure(
            with: ViewModel(
                title: TextConstants.ChangePass.newPassTitle.localized(),
                placeholder: TextConstants.ChangePass.newPassPlaceholder.localized(),
                type: .password
            )
        )
        
        confirmPassField.configure(
            with: ViewModel(
                title: TextConstants.ChangePass.confirmPassTitle.localized(),
                placeholder: TextConstants.ChangePass.confirmPassPlaceholder.localized(),
                type: .password
            )
        )
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    @objc func changePassButtonAction() {
        presenter.changePassButtonAction()
    }
}
