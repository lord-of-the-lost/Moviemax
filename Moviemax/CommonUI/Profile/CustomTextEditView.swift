//
//  CustomTextEditView.swift
//  Moviemax
//
//  Created by Volchanka on 02.04.2025.
//

import UIKit
import SnapKit

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

enum TextEditVIewType {
    case textField
    case date
    case textView
    case gender(Gender)
}

#warning("Нужен рефакторинг, можешь отсюда убрать гендер вью, но остальное тоже можно перепроектировать, если время останется, то сделаем, а пока важно вынести отдельно гендер вью и пометить тудушкой класс к рефакторингу")
final class CustomTextEditView: UIView {
    
    // MARK: Properties
    private lazy var borderView = BorderView()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
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
    
    private lazy var genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Constraints.defaultOffset
        return stackView
    }()
    
    // MARK: Init
    init(text: String, labelName: String, type: TextEditVIewType) {
        super.init(frame: .zero)
        
        label.text = labelName
       
        switch type {
        case .textField:
            setupDefaultUI(with: text)
        case .date:
            setupDateUI(with: text)
        case .textView:
            setupTextViewUI(with: text)
        case .gender (let currentGender):
            setupGenderUI(with: currentGender)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension CustomTextEditView {
    
    func setupDefaultUI(with text: String) {
        defaultTextField.text = text
        
        addSubviews(label, borderView, defaultTextField)
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        borderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
        }
        
        defaultTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            make.trailing.equalToSuperview().inset(Constants.Constraints.defaultOffset)
            make.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupDateUI(with text: String) {
        setupDefaultUI(with: text)
        addSubview(calendarIcon)
        calendarIcon.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.Constraints.calndarIconSize)
            make.centerY.equalTo(borderView)
            make.right.equalToSuperview().inset(Constants.Constraints.smallOffset)
        }
    }
    
    func setupTextViewUI(with text: String) {
        textView.text = text
        addSubviews(label, borderView, textView)
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        borderView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            make.trailing.equalToSuperview().inset(Constants.Constraints.defaultOffset)
            make.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupGenderUI(with gender: Gender) {
        addSubview(genderStackView)
        addSubview(label)

        let maleView = GenderView(gender: .male, isSelected: gender == .male)
        genderStackView.addArrangedSubview(maleView)
        
        let femaleView = GenderView(gender: .female, isSelected: gender == .female)
        genderStackView.addArrangedSubview(femaleView)
        
        genderStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(Constants.Constraints.smallOffset)
            make.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Constants.Constraints.labelHeight)
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
            static let calndarIconSize: CGFloat = 24
        }
    }
}
