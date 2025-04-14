//
//  DatePickerView.swift
//  Moviemax
//
//  Created by Николай Игнатов on 09.04.2025.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func didTapDatePickerView()
}

final class DatePickerView: UIView {
    // MARK: - Properties
    weak var delegate: DatePickerViewDelegate?
    
    private lazy var borderView = BorderView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.label)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaMedium.withSize(Constants.FontSizes.textField)
        return label
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imageView = UIImageView(image: .calendarProfile)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init
    init(labelName: String) {
        super.init(frame: .zero)
        titleLabel.text = labelName
        
        setupUI()
        setupConstraints()
        setupGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension DatePickerView {
    func getDateString() -> String {
        dateLabel.text ?? ""
    }
    
    func setDateString(_ dateString: String) {
        dateLabel.text = dateString
    }
}

// MARK: - Private Methods
private extension DatePickerView {
    func setupUI() {
        addSubviews(
            titleLabel,
            borderView,
            dateLabel,
            calendarIcon
        )
        
        isUserInteractionEnabled = true
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Constraints.smallOffset)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            $0.trailing.equalToSuperview().inset(Constants.Constraints.defaultOffset)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Constraints.smallOffset)
            $0.bottom.equalToSuperview()
        }
        
        calendarIcon.snp.makeConstraints {
            $0.size.equalTo(Constants.Constraints.calendarIconSize)
            $0.centerY.equalTo(borderView)
            $0.trailing.equalToSuperview().inset(Constants.Constraints.smallOffset)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        delegate?.didTapDatePickerView()
    }
}

// MARK: - Constants
private extension DatePickerView {
    enum Constants {
        enum FontSizes {
            static let label: CGFloat = 14
            static let textField: CGFloat = 16
        }
        
        enum Constraints {
            static let labelHeight: CGFloat = 22
            static let smallOffset: CGFloat = 8
            static let defaultOffset: CGFloat = 16
            static let calendarIconSize: CGFloat = 24
        }
    }
} 
