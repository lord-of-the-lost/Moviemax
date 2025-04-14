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
        imageView.layer.cornerRadius = Constants.Sizes.cornerRadius
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
        view.layer.cornerRadius = Constants.Sizes.genreCornerRadius
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
    
    // TODO: выпилить
    static let mockData: [MovieLargeCellViewModel] = [
        MovieLargeCellViewModel(
            title: "Drifting Home",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "148 Minutes",
            reliseDate: "17 Sep 2021",
            genre: "Animation",
            isLiked: false
        ),
        MovieLargeCellViewModel(
            title: "The Batman",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "176 Minutes",
            reliseDate: "4 Mar 2022",
            genre: "Action",
            isLiked: true
        ),
        MovieLargeCellViewModel(
            title: "Everything Everywhere All at Once",
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "139 Minutes",
            reliseDate: "25 Mar 2022",
            genre: "Adventure",
            isLiked: false
        )
    ]
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
            $0.width.equalTo(Constants.Sizes.posterWidth)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.Spacing.bottomInset)
        }
        
        movieName.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.top)
            $0.leading.equalTo(movieImage.snp.trailing).offset(Constants.Spacing.horizontalOffset)
            $0.trailing.equalTo(likeButton.snp.leading).offset(Constants.Spacing.movieNameTrailing.negative)
        }
        
        timeIcon.snp.makeConstraints {
            $0.top.equalTo(movieName.snp.bottom).offset(Constants.Spacing.verticalSpacing)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(Constants.Sizes.iconSize)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon)
            $0.leading.equalTo(timeIcon.snp.trailing).offset(Constants.Spacing.iconTextSpacing)
        }
        
        dateIcon.snp.makeConstraints {
            $0.top.equalTo(timeIcon.snp.bottom).offset(Constants.Spacing.verticalSpacing)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(Constants.Sizes.iconSize)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateIcon)
            $0.leading.equalTo(dateIcon.snp.trailing).offset(Constants.Spacing.iconTextSpacing)
        }
        
        movieIcon.snp.makeConstraints {
            $0.top.equalTo(dateIcon.snp.bottom).offset(Constants.Spacing.verticalSpacing)
            $0.leading.equalTo(movieName.snp.leading)
            $0.size.equalTo(Constants.Sizes.iconSize)
        }
        
        genreView.snp.makeConstraints {
            $0.centerY.equalTo(movieIcon)
            $0.leading.equalTo(movieIcon.snp.trailing).offset(Constants.Spacing.iconTextSpacing)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.Spacing.genreVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(Constants.Spacing.genrePadding)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(movieImage)
            $0.trailing.equalToSuperview().offset(Constants.Spacing.likeButtonTrailing.negative)
            $0.size.equalTo(Constants.Sizes.likeButtonSize)
        }
    }
    
    @objc func likeButtonTapped() {
        likeButton.toggleLike()
        delegate?.likeTapped(self)
    }
}

// MARK: - Constants
private extension MovieLargeCell {
    enum Constants {
        enum Sizes {
            static let posterWidth: CGFloat = 120
            static let iconSize: CGFloat = 16
            static let likeButtonSize: CGFloat = 24
            static let cornerRadius: CGFloat = 16
            static let genreCornerRadius: CGFloat = 6
        }
        
        enum Spacing {
            static let bottomInset: CGFloat = 24
            static let horizontalOffset: CGFloat = 15
            static let likeButtonTrailing: CGFloat = 6
            static let movieNameTrailing: CGFloat = 10
            static let verticalSpacing: CGFloat = 12
            static let iconTextSpacing: CGFloat = 5
            static let genrePadding: CGFloat = 16
            static let genreVerticalPadding: CGFloat = 3
        }
    }
}
