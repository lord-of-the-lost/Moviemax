//
//  MovieDetailView.swift
//  Moviemax
//
//  Created by Penkov Alexander on 05.04.2025.
//

import UIKit

final class MovieDetailView: UIView {
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppFont.montserratMedium.withSize(12)
        label.textColor = .adaptiveTextSecondary
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
        
    func configure(with text: String, image: UIImage) {
        textLabel.text = text
        detailImageView.image = image.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextSecondary)
    }
}

// MARK: - Private Methods
private extension MovieDetailView {
    func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(detailImageView)
        stackView.addArrangedSubview(textLabel)
        
        detailImageView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
