//
//  GenderView.swift
//  Moviemax
//
//  Created by Volchanka on 03.04.2025.
//

import UIKit
import SnapKit

final class GenderView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .label
        return label
    }()
    
    private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: .checkmarkFill)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let borderView = BorderView()

    
    init(gender: Gender, isSelected: Bool) {
        super.init(frame: .zero)
        label.text = gender.rawValue
        if isSelected {
            checkmarkImageView = .init(image: .checkmarkFill)
        } else {
            checkmarkImageView = .init(image: .checkmarkEmpty)
        }
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GenderView {
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
            make.left.equalToSuperview().offset(Constants.Constraints.defaultOffset)
            make.centerY.equalTo(borderView)
            make.width.height.equalTo(Constants.Constraints.labelHeight)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(checkmarkImageView.snp.right).offset(Constants.Constraints.defaultOffset)
            make.centerY.equalTo(borderView)
            make.height.equalTo(Constants.Constraints.labelHeight)
        }
    }
}

// MARK: - Constants
private extension GenderView {
    enum Constants {
        enum Constraints {
            static let viewHeight: CGFloat = 48
            static let labelHeight: CGFloat = 24
            static let defaultOffset: CGFloat = 16
        }
    }
}

