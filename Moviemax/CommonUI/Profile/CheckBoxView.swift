//
//  GenderView.swift
//  Moviemax
//
//  Created by Volchanka on 03.04.2025.
//

import UIKit
import SnapKit


protocol CheckBoxViewDelegate: AnyObject {
    func checkBoxViewDidToggle(_ view: CheckBoxView)
}

final class CheckBoxView: UIView {
    
    // MARK: Properties
    weak var delegate: CheckBoxViewDelegate?
    
    private lazy var borderView = BorderView()
    private lazy var checkedImage: UIImage = .checkmarkFill
    private lazy var uncheckedImage: UIImage = .checkmarkEmpty
    private lazy var isChecked = false {
        didSet {
            updateImage()
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
        isChecked = isSelected
        setupUI(text: text)
        setupTap()
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
    func setupUI(text: String) {
        label.text = text
        addSubviews(borderView, label, checkmarkImageView)
        setupConstraints()
    }
    
    func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    @objc func didTap() {
        delegate?.checkBoxViewDidToggle(self)
    }
    
    func updateImage() {
        checkmarkImageView.image = isChecked ? checkedImage : uncheckedImage
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

