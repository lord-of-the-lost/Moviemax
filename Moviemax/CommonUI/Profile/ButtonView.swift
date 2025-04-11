//
//  ButtonView.swift
//  Moviemax
//
//  Created by Volchanka on 11.04.2025.
//

import UIKit

final class ButtonView: UIView {
   
    private lazy var imageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        return label
    }()
    
    init(title: String, color: UIColor, icon: UIImage) {
        super.init(frame: .zero)
        setupUI(title: title, color: color, icon: icon)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ButtonView {
    func setupUI(title: String, color: UIColor, icon: UIImage) {
        layer.cornerRadius = 8
        backgroundColor = .backgroundSecondary
        
        imageView.image = icon
        imageView.tintColor = color
        
        titleLabel.text = title
        titleLabel.textColor = color
        
        addSubviews(titleLabel, imageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().inset(18)
        }
    }
}

