//
//  TitledTextField.swift
//  Moviemax
//
//  Created by Николай Игнатов on 06.04.2025.
//


import UIKit
import SnapKit

// MARK: - TitledTextField
final class TitledTextField: UIView {
    private let textField: CommonTextField
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaRegular.withSize(14)
        label.textColor = .adaptiveTextSecondary
        return label
    }()
    
    init(isSecure: Bool = false) {
        self.textField = CommonTextField(isSecure: isSecure)
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TextFieldViewModel) {
        titleLabel.text = viewModel.title
        let model = CommonTextField.TextFieldViewModel(placeholder: viewModel.placeholder, type: viewModel.type)
        textField.configure(with: model)
    }
    
    func getText() -> String? {
        textField.text
    }
}

// MARK: - Helper Entities
extension TitledTextField {
    struct TextFieldViewModel {
        let title: String
        let placeholder: String
        let type: TextFieldType
    }
}

// MARK: - Private Methods
private extension TitledTextField {
    func setupView() {
        addSubviews(titleLabel, textField)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
