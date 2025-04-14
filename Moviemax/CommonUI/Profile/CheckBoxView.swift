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
    // MARK: - Properties
    weak var delegate: CheckBoxViewDelegate?
    
    private lazy var borderView = BorderView()
    private lazy var checkedImage: UIImage = .checkmarkFill
    private lazy var uncheckedImage: UIImage = .checkmarkEmpty
    private lazy var checkState = false {
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
    
    // MARK: - Init
    init(text: String, isSelected: Bool) {
        super.init(frame: .zero)
        checkState = isSelected
        setupUI(text: text)
        setupTap()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CheckBoxView {
    func setChecked(_ checked: Bool) {
        checkState = checked
    }
    
    var isChecked: Bool {
        return checkState
    }
}

// MARK: - Private methods
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
        checkmarkImageView.image = checkState ? checkedImage : uncheckedImage
    }
    
    func setupConstraints() {
        borderView.snp.makeConstraints {
            $0.height.equalTo(Constants.Constraints.viewHeight)
            $0.left.right.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.left
                .equalToSuperview()
                .offset(Constants.Constraints.defaultOffset)
            $0.centerY.equalTo(borderView)
            $0.width.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        label.snp.makeConstraints {
            $0.left
                .equalTo(checkmarkImageView.snp.right)
                .offset(Constants.Constraints.defaultOffset)
            $0.centerY.equalTo(borderView)
            $0.height.equalTo(Constants.Constraints.labelHeight)
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

