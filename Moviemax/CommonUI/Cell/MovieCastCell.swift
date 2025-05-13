//
//  MovieCastCell.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit

final class MovieCastCell: UICollectionViewCell {
    static let identifier = MovieCastCell.description()
    
    private lazy var castImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var castName: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(14)
        return label
    }()
    
    private lazy var castDescription: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(10)
        label.textColor = .adaptiveTextMain
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        castImage.image = nil
        castName.text = nil
        castDescription.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: MovieCastCellViewModel) {
        castName.text = model.castName
        castImage.image = model.castImage
        castDescription.text = model.castDescription
    }
}

// MARK: - MovieCastCellViewModel
extension MovieCastCell {
    struct MovieCastCellViewModel {
        let castImage: UIImage
        let castName: String
        let castDescription: String
    }
}

// MARK: - Private Methods
private extension MovieCastCell {
    func setupView() {
        contentView.backgroundColor = .clear
        castImage.layer.cornerRadius = 20
        contentView.addSubviews(
            castImage,
            castName,
            castDescription
        )
    }
    
    func setupConstraints() {
        castImage.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        castName.snp.makeConstraints {
            $0.left.equalTo(castImage.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.top.equalTo(castImage.snp.top)
            $0.height.equalTo(castImage.snp.height).dividedBy(2)
        }
        
        castDescription.snp.makeConstraints {
            $0.left.equalTo(castImage.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(castImage.snp.bottom)
            $0.height.equalTo(castImage.snp.height).dividedBy(2)
        }
    }
}
