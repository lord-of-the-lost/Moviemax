//
//  GenderView.swift
//  Moviemax
//
//  Created by Volchanka on 03.04.2025.
//

import UIKit
import SnapKit


final class CheckBoxView: UIView {
    
    // MARK: Properties
    var onTap: (() -> Void)?
    
    private lazy var borderView = BorderView()
    private lazy var checkedImage: UIImage = .checkmarkFill
    private lazy var uncheckedImage: UIImage = .checkmarkEmpty

    private var isChecked = false {
        didSet {
            updateCheckbox()
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .label
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: .checkmarkFill)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Init
    init(text: String, isSelected: Bool) {
        super.init(frame: .zero)
        
        label.text = text
        checkmarkImageView.image = isSelected ? checkedImage : uncheckedImage
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleCheckbox)
        )
        addGestureRecognizer(tapGesture)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func setChecked(_ checked: Bool) {
        isChecked = checked
    }
}

//MARK: - Private methods
private extension CheckBoxView {
    func setupUI() {
        addSubviews(borderView, label, checkmarkImageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        borderView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.viewHeight)
            make.left.right.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.left
                .equalToSuperview()
                .offset(Constants.Constraints.defaultOffset)
            make.centerY.equalTo(borderView)
            make.width.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        label.snp.makeConstraints { make in
            make.left
                .equalTo(checkmarkImageView.snp.right)
                .offset(Constants.Constraints.defaultOffset)
            make.centerY.equalTo(borderView)
            make.height.equalTo(Constants.Constraints.labelHeight)
        }
    }
    
    func updateCheckbox() {
        checkmarkImageView.image = isChecked ? checkedImage : uncheckedImage
    }
    
    @objc func toggleCheckbox() {
        isChecked.toggle()
        onTap?()
    }
}

// MARK: - Constants
private extension CheckBoxView {
    enum Constants {
        enum Constraints {
            static let viewHeight: CGFloat = 48
            static let labelHeight: CGFloat = 24
            static let defaultOffset: CGFloat = 16
        }
    }
}

