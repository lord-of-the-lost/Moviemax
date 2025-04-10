//
//  SearchFieldView.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit
import SnapKit

final class SearchFieldView: UIView {
    
    // MARK: - Public Properties
    var rightButtonAction: (() -> Void)?
    
    // MARK: - Private Properties
    private lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .close), for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .filter), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.accent.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 26
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 0))
        textField.rightViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
        
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}

// MARK: - Private Methods
private extension SearchFieldView {
    private func setupUI() {
        addSubview(searchTextField)
        addSubview(searchIconImageView)
        addSubview(clearButton)
        addSubview(separatorView)
        addSubview(rightButton)
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.leading.equalTo(searchTextField).offset(16)
            $0.width.height.equalTo(20)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(separatorView.snp.leading).offset(-8)
            $0.width.height.equalTo(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(rightButton.snp.leading).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(20)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchTextField).offset(-16)
            $0.width.height.equalTo(20)
        }
    }
    
    @objc private func clearButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        updateClearButtonVisibility()
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction?()
    }
    
    @objc private func textFieldDidChange() {
        updateClearButtonVisibility()
    }
    
    private func updateClearButtonVisibility() {
        let hasText = !(searchTextField.text?.isEmpty ?? true)
        clearButton.isHidden = !hasText
        separatorView.isHidden = !hasText
    }
}
