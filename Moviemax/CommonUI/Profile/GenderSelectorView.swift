//
//  GenderSelectorView.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

import UIKit

protocol GenderSelectorViewDelegate: AnyObject {
    func genderSelectorView(_ view: GenderSelectorView, didSelect gender: User.Gender)
}

final class GenderSelectorView: UIView {
    
    // MARK: - Properties
    weak var delegate: GenderSelectorViewDelegate?

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.labelText
        label.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.label)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var maleView = CheckBoxView(
        text: User.Gender.male.rawValue,
        isSelected: true
    )
    
    private lazy var femaleView = CheckBoxView(
        text: User.Gender.female.rawValue,
        isSelected: false
    )
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Constraints.defaultOffset
        return stackView
    }()
    
    // MARK: - Init
    init(selectedGender: User.Gender) {
        super.init(frame: .zero)
        setupUI(selectedGender: selectedGender)
        setupDelegates()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension GenderSelectorView {
    func getSelectedGender() -> User.Gender {
        maleView.isChecked ? .male : .female
    }
    
    func selectGender(_ gender: User.Gender) {
        maleView.setChecked(gender == .male)
        femaleView.setChecked(gender == .female)
        delegate?.genderSelectorView(self, didSelect: gender)
    }
}

// MARK: - Private methods
private extension GenderSelectorView {
    func setupUI(selectedGender: User.Gender) {
        addSubviews(stackView, label)
        stackView.addArrangedSubviews(maleView, femaleView)
        setupConstraints()
        
        maleView.setChecked(selectedGender == .male)
        femaleView.setChecked(selectedGender == .female)
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
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
    
    func setupDelegates() {
        maleView.delegate = self
        femaleView.delegate = self
    }
}

extension GenderSelectorView: CheckBoxViewDelegate {
    func checkBoxViewDidToggle(_ view: CheckBoxView) {
        if view == maleView {
            selectGender(.male)
        } else if view == femaleView {
            selectGender(.female)
        }
    }
}

// MARK: - Constants
private extension GenderSelectorView {
    enum Constants {
        enum Text {
            static let labelText: String = "Gender"
        }
        enum FontSizes {
            static let label: CGFloat = 14
        }
        enum Constraints {
            static let labelHeight: CGFloat = 22
            static let smallOffset: CGFloat = 8
            static let defaultOffset: CGFloat = 16
        }
    }
}
