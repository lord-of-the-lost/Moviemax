//
//  CustomTextEditView.swift
//  Moviemax
//
//  Created by Volchanka on 02.04.2025.
//

import UIKit
import SnapKit

enum TextEditViewType {
    case textField
    case date
    case textView
}

final class CustomTextEditView: UIView {
    // MARK: - Properties
    private var currentType: TextEditViewType = .textField
    private lazy var borderView = BorderView()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.label)
        label.textColor = .lightGray
        return label
    }()
    
    private let calendarIcon: UIImageView = {
        let imageView = UIImageView(image: .calendarProfile)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var defaultTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .adaptiveTextMain
        textField.borderStyle = .none
        textField.tintColor = .accent
        textField.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.textField)
        return textField
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.textView)
        textView.textColor = .adaptiveTextMain
        textView.backgroundColor = .clear
        return textView
    }()
    
    // MARK: - Init
    init(labelName: String, type: TextEditViewType) {
        super.init(frame: .zero)
        label.text = labelName
        currentType = type
        switch currentType {
        case .textField:
            setupDefaultUI()
        case .date:
            setupDateUI()
        case .textView:
            setupTextViewUI()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension CustomTextEditView {
    func getText() -> String? {
        switch currentType {
        case .textView:
            return textView.text
        case .textField, .date:
            return defaultTextField.text
        }
    }
    
    func updateText(_ text: String) {
        switch currentType {
        case .textView:
            textView.text = text
        case .textField, .date:
            defaultTextField.text = text
        }
    }
}

// MARK: - Private Methods
private extension CustomTextEditView {
    func setupDefaultUI() {
        addSubviews(label, borderView, defaultTextField)
        
        label.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
        }
        
        defaultTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            $0.trailing.equalToSuperview().inset(Constants.Constraints.defaultOffset)
            $0.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDateUI() {
        setupDefaultUI()
        addSubview(calendarIcon)
        calendarIcon.snp.makeConstraints {
            $0.height.width.equalTo(Constants.Constraints.calendarIconSize)
            $0.centerY.equalTo(borderView)
            $0.right.equalToSuperview().inset(Constants.Constraints.smallOffset)
        }
    }
    
    func setupTextViewUI() {
        addSubviews(label, borderView, textView)
        
        label.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
        }
        
        textView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            $0.trailing.equalToSuperview().inset(Constants.Constraints.defaultOffset)
            $0.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension CustomTextEditView {
    enum Constants {
        enum FontSizes {
            static let label: CGFloat = 14
            static let textField: CGFloat = 16
            static let textView: CGFloat = 16
        }
        
        enum Constraints {
            static let labelHeight: CGFloat = 22
            static let smallOffset: CGFloat = 8
            static let defaultOffset: CGFloat = 16
            static let genderViewHeight: CGFloat = 48
            static let calendarIconSize: CGFloat = 24
        }
    }
}
