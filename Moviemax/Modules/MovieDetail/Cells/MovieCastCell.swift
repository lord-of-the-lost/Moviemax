//
//  MovieCastCell.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class MovieCastCell: UICollectionViewCell {
    static let identifier = MovieCastCell.description()
    
    private lazy var castImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
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
        setupUI()
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
    
    // TODO: выпилить
    static let mockData: [MovieCastCellViewModel] = [
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        ),
        MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: "Jon Watts",
            castDescription: "Directors"
        )
    ]
}

// MARK: - Private Methods
private extension MovieCastCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        castImage.layer.cornerRadius = Constants.cornerRadius
        contentView.addSubviews(
            castImage,
            castName,
            castDescription
        )
    }
    
    func setupConstraints() {
        castImage.snp.makeConstraints {
            $0.size.equalTo(Constants.imageSize)
            $0.leading.equalToSuperview().offset(Constants.horizontalOffset)
            $0.centerY.equalToSuperview()
        }
        
        castName.snp.makeConstraints {
            $0.left.equalTo(castImage.snp.right).offset(Constants.horizontalOffset)
            $0.right.equalToSuperview()
            $0.top.equalTo(castImage.snp.top)
            $0.height.equalTo(Constants.imageSize/2)
        }
        
        castDescription.snp.makeConstraints {
            $0.left.equalTo(castImage.snp.right).offset(Constants.horizontalOffset)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(castImage.snp.bottom)
            $0.height.equalTo(Constants.imageSize/2)
        }
    }
}

// MARK: - Constants
private extension MovieCastCell {
    enum Constants {
        static let imageSize: CGFloat = 40
        static let cornerRadius: CGFloat = 20
        static let horizontalOffset: CGFloat = 8
        static let verticalOffset: CGFloat = 4
    }
}
