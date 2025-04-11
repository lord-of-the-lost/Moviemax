//
//  UserHeaderView.swift
//  Moviemax
//
//  Created by Николай Игнатов on 11.04.2025.
//

import UIKit

final class UserHeaderView: UIView {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.avatarSize.half
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(Constants.nameFontSize)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaRegular.withSize(Constants.statusFontSize)
        label.textColor = .adaptiveTextSecondary
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: UserHeaderViewModel) {
        nameLabel.text = model.greeting
        statusLabel.text = model.status
        avatarImageView.image = model.avatar
    }
}

// MARK: - UserHeaderViewModel
extension UserHeaderView {
    struct UserHeaderViewModel {
        let greeting: String
        let status: String
        let avatar: UIImage
    }
}

// MARK: - Private Methods
private extension UserHeaderView {
    func setupView() {
        addSubviews(
            avatarImageView,
            nameLabel,
            statusLabel
        )
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.avatarSize)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.top)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(Constants.horizontalSpacing)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - Constants

private extension UserHeaderView {
    enum Constants {
        static let avatarSize: CGFloat = 40
        static let nameFontSize: CGFloat = 18
        static let statusFontSize: CGFloat = 12
        static let horizontalSpacing: CGFloat = 15
    }
} 
