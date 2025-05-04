//
//  MovieLargeCell.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

import UIKit

protocol MovieLargeCellDelegate: AnyObject {
    func likeTapped(_ cell: MovieLargeCell)
}

final class MovieLargeCell: UITableViewCell {
    weak var delegate: MovieLargeCellDelegate?
    static let identifier = MovieLargeCell.description()
    
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextMain
        label.numberOfLines = 2
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
    
    private lazy var dateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .calendar).withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextSecondary)
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.montserratMedium.withSize(12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var movieIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .movie).withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextSecondary)
        return imageView
    }()
    
    private lazy var genreView: UIView = {
        let view = UIView()
        view.addSubview(genreLabel)
        view.backgroundColor = .accent
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.montserratMedium.withSize(12)
        label.textColor = .strictWhite
        return label
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieName.text = nil
        timeLabel.text = nil
        dateLabel.text = nil
        genreLabel.text = nil
        likeButton.setLiked(false)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: MovieLargeCellViewModel) {
        movieName.text = model.title
        movieImage.image = model.poster
        dateLabel.text = model.reliseDate
        timeLabel.text = model.filmLength
        genreLabel.text = model.genre
        likeButton.setLiked(model.isLiked)
    }
}

// MARK: - MovieLargeCellViewModel
extension MovieLargeCell {
    struct MovieLargeCellViewModel {
        let title: String
        var poster: UIImage
        let filmLength: String
        let reliseDate: String
        let genre: String
        var isLiked: Bool
    }
}

// MARK: - Private Methods
private extension MovieLargeCell {
    func setupViews() {
        contentView.backgroundColor = .appBackground
        contentView.addSubviews(
            movieImage,
            movieName,
            timeIcon,
            timeLabel,
            dateIcon,
            dateLabel,
            movieIcon,
            genreView,
            likeButton
        )
    }
    
    func setupConstraints() {
        movieImage.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        movieName.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.top)
            $0.leading.equalTo(movieImage.snp.trailing).offset(15)
            $0.trailing.equalTo(likeButton.snp.leading).offset(-10)
        }
        
        timeIcon.snp.makeConstraints {
            $0.top.equalTo(movieName.snp.bottom).offset(12)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon)
            $0.leading.equalTo(timeIcon.snp.trailing).offset(5)
        }
        
        dateIcon.snp.makeConstraints {
            $0.top.equalTo(timeIcon.snp.bottom).offset(12)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon)
            $0.leading.equalTo(dateIcon.snp.trailing).offset(5)
        }
        
        movieIcon.snp.makeConstraints {
            $0.top.equalTo(dateIcon.snp.bottom).offset(12)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(16)
        }
        
        genreView.snp.makeConstraints {
            $0.centerY.equalTo(movieIcon)
            $0.leading.equalTo(movieIcon.snp.trailing).offset(5)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(movieImage)
            $0.trailing.equalToSuperview().offset(-6)
            $0.size.equalTo(24)
        }
    }
    
    @objc func likeButtonTapped() {
        likeButton.toggleLike()
        delegate?.likeTapped(self)
    }
}
