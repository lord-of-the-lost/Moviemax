//
//  PosterCell.swift
//  Moviemax
//
//  Created by Николай Игнатов on 11.04.2025.
//

import UIKit

final class PosterCell: UICollectionViewCell {
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.image = .posterPlaceholder
        return imageView
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaBold.withSize(16)
        label.textColor = .white
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.font = AppFont.plusJakartaMedium.withSize(18)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: PosterCellViewModel) {
        movieName.text = model.title
        categoryLabel.text = "  \(model.category)  "
        movieImage.image = model.image
    }
}

extension PosterCell {
    struct PosterCellViewModel {
        let title: String
        let category: String
        var image: UIImage
    }
}

// MARK: - Private Methods
private extension PosterCell {
    func setupView() {
        contentView.addSubviews(movieImage, movieName, categoryLabel)
    }
    
    func setupConstraints() {
        movieImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(movieImage).offset(-110)
        }
        
        movieName.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(5)
            $0.leading.equalTo(movieImage).offset(15)
        }
    }
}
