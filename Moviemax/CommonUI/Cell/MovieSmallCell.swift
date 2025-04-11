//
//  MovieSmallCell.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import UIKit

protocol MovieSmallCellDelegate: AnyObject {
    func likeTapped(_ cell: MovieSmallCell)
}

final class MovieSmallCell: UITableViewCell {
    weak var delegate: MovieSmallCellDelegate?
    static let identifier = MovieSmallCell.description()
    
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(12)
        label.textColor = .adaptiveTextSecondary
        return label
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextMain
        label.numberOfLines = 1
        label.font = AppFont.plusJakartaBold.withSize(18)
        return label
    }()
    
    private lazy var timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .clock).withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextSecondary)
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.montserratMedium.withSize(12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .star)
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warning
        label.font = AppFont.plusJakartaSemiBold.withSize(12)
        return label
    }()
    
    private lazy var voiceCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.plusJakartaSemiBold.withSize(12)
        return label
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieName.text = nil
        timeLabel.text = nil
        likeButton.setLiked(false)
    }
    
    // MARK: - Configuration
    func configure(with model: MovieSmallCellViewModel) {
        movieName.text = model.title
        movieImage.image = model.poster
        timeLabel.text = model.filmLength
        ratingLabel.text = model.rating
        voiceCountLabel.text = model.voiceCount
        categoryLabel.text = model.genre
        likeButton.setLiked(model.isLiked)
    }
}

// MARK: - MovieSmallCellViewModel
extension MovieSmallCell {
    struct MovieSmallCellViewModel {
        let title: String
        let poster: UIImage
        let filmLength: String
        let genre: String
        let rating: String
        let voiceCount: String
        let isLiked: Bool
    }
    
    // TODO: выпилить
    static let mockData: [MovieSmallCellViewModel] = [
        MovieSmallCellViewModel(
            title: "Drifting Home",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "148 Minutes",
            genre: "Animation",
            rating: "4.2",
            voiceCount: "(17)",
            isLiked: false
        ),
        MovieSmallCellViewModel(
            title: "The Batman",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "176 Minutes",
            genre: "Action",
            rating: "4.8",
            voiceCount: "(117)",
            isLiked: false
        ),
        MovieSmallCellViewModel(
            title: "Everything Everywhere All at Once",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "139 Minutes",
            genre: "Adventure",
            rating: "3.8",
            voiceCount: "(90)",
            isLiked: false
        ),
    ]
}

// MARK: - Private Methods
private extension MovieSmallCell {
    func setupViews() {
        contentView.backgroundColor = .appBackground
        contentView.addSubviews(
            movieImage,
            categoryLabel,
            movieName,
            timeIcon,
            timeLabel,
            starImage,
            ratingLabel,
            voiceCountLabel,
            likeButton
        )
    }
    
    func setupConstraints() {
        movieImage.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(23)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.top).offset(5)
            $0.leading.equalTo(movieImage.snp.trailing).offset(12)
        }
        
        movieName.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(3)
            $0.leading.equalTo(movieImage.snp.trailing).offset(12)
            $0.trailing.equalTo(likeButton.snp.leading).offset(-5)
        }
        
        timeIcon.snp.makeConstraints {
            $0.top.equalTo(movieName.snp.bottom).offset(12)
            $0.leading.equalTo(movieName.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon.snp.centerY)
            $0.leading.equalTo(timeIcon.snp.trailing).offset(5)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.top)
            $0.trailing.equalToSuperview().offset(-22)
            $0.size.equalTo(20)
        }
        
        voiceCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.centerY.equalTo(timeLabel.snp.centerY)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.trailing.equalTo(voiceCountLabel.snp.leading).offset(-3)
            $0.centerY.equalTo(timeLabel.snp.centerY)
        }
        
        starImage.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.trailing.equalTo(ratingLabel.snp.leading).offset(-5)
        }
    }
    
    @objc func likeButtonTapped() {
        likeButton.toggleLike()
        delegate?.likeTapped(self)
    }
}
