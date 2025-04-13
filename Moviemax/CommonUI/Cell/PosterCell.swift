//
//  PosterCell.swift
//  Moviemax
//
//  Created by Николай Игнатов on 11.04.2025.
//

import UIKit

final class PosterCell: UICollectionViewCell {
    static let identifier = MovieSmallCell.description()
    
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.image = .posterPlaceholder
        return imageView
    }()
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0.6, 1.0]
        gradient.frame = movieImage.bounds
        return gradient
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaBold.withSize(14)
        label.textColor = .white
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray.withAlphaComponent(0.5)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = AppFont.plusJakartaMedium.withSize(10)
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
        movieImage.layer.addSublayer(gradient)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradient.frame = movieImage.bounds
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
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(movieImage).offset(15)
            $0.bottom.equalTo(movieName.snp.top).offset(-10)
            $0.height.equalTo(20)
        }
        
        movieName.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(15)
            $0.leading.equalTo(movieImage).offset(15)
            $0.trailing.equalTo(movieImage).inset(15)
        }
    }
}
