//
//  CommonTextField.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//

import UIKit

enum TextFieldType {
    case regular, password, email, phone
}

final class CommonTextField: UIView {
    private var isPasswordVisible = false
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    init(isSecure: Bool = false, placeholder: String? = nil) {
        super.init(frame: .zero)
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeholder
        setupView()
        setupConstraints()
        setupEyeButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TextFieldViewModel) {
        textField.placeholder = viewModel.placeholder
        
        switch viewModel.type {
        case .regular:
            textField.isSecureTextEntry = false
            textField.keyboardType = .default
        case .password:
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
        case .email:
            textField.isSecureTextEntry = false
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case .phone:
            textField.isSecureTextEntry = false
            textField.keyboardType = .phonePad
        }
    }
}

// MARK: - Helper Entities
extension CommonTextField {
    struct TextFieldViewModel {
        let placeholder: String
        let type: TextFieldType
    }
}

// MARK: - Private Methods
private extension CommonTextField {
    func setupView() {
        addSubview(textField)
        addSubview(eyeButton)
        backgroundColor = .mainColorSecondary
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.textFieldBorder.cgColor
    }
    
    func setupEyeButton() {
        guard textField.isSecureTextEntry else { return }
        eyeButton.isHidden = false
    }
    
    func setupConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        eyeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        eyeButton.setImage(UIImage(systemName: isPasswordVisible ? "eye" : "eye.slash"), for: .normal)
    }
}
