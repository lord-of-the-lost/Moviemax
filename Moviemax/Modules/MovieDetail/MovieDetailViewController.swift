//
//  MovieDetailViewController.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {
    private let presenter: MovieDetailPresenter
    private lazy var likeButton = LikeButton()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView(image: .movieDetail)
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.movieTitle
        label.textAlignment = .center
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(24)
        return label
    }()
    
    private lazy var movieDateView: UIView = {
        let view = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .calendar)
        imageView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }

        let label = UILabel()
        label.text = Constants.Text.movieDate
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.montserratMedium.withSize(12)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var movieDurationView: UIView = {
        let view = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .clock)
        imageView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }

        let label = UILabel()
        label.text = Constants.Text.movieDuration
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.montserratMedium.withSize(12)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        return view
    }()
    
    private lazy var movieGenreView: UIView = {
        let view = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .film)
        imageView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(16)
        }

        let label = UILabel()
        label.text = Constants.Text.movieGenre
        label.textColor = .adaptiveTextSecondary
        label.font = AppFont.montserratMedium.withSize(12)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var movieRatingView: RatingView = RatingView(rating: 3.5)
    
    private lazy var movieDescriptionTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.movieDescriptionTitle
        label.textAlignment = .left
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var movieDescriptionDetail: DescriptionDetail = DescriptionDetail(text: Constants.Text.movieDescriptionText)
    
    private lazy var movieCastTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.movieCastTitle
        label.textAlignment = .left
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        return label
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCastCell.self, forCellWithReuseIdentifier: MovieCastCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var watchButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabBarBG
        
        let button = CommonButton(title: Constants.Text.watchButtonTitle)
        button.addTarget(self, action: #selector(watchNowButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(56)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(button)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    init(presenter: MovieDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MovieDetailViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(movieImageView,
                                movieTitleLabel,
                                movieDurationView,
                                movieDateView,
                                movieGenreView,
                                movieRatingView,
                                movieDescriptionTitle,
                                movieDescriptionDetail,
                                movieCastTitle,
                                castCollectionView)
        
        view.addSubview(watchButtonView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        watchButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(watchButtonView.snp.top)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        movieImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(movieImageView.snp.width).multipliedBy(1.35)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        movieDurationView.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(16)
        }
        
        movieDateView.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            $0.right.equalTo(movieDurationView.snp.left).offset(-8)
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(16)
        }
        
        movieGenreView.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            $0.left.equalTo(movieDurationView.snp.right).offset(8)
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(16)
        }
        
        movieRatingView.snp.makeConstraints {
            $0.top.equalTo(movieDurationView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.width.equalTo(104)
        }
                
        movieDescriptionTitle.snp.makeConstraints {
            $0.top.equalTo(movieRatingView.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        movieDescriptionDetail.snp.makeConstraints {
            $0.top.equalTo(movieDescriptionTitle.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        movieCastTitle.snp.makeConstraints {
            $0.top.equalTo(movieDescriptionDetail.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(movieCastTitle.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(104)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
    
    func setupNavigation() {
        self.title = Constants.Text.screenTitle
                
        let backButton = UIButton()
        backButton.setImage(UIImage(resource: .arrowBack), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: AppFont.montserratBold.withSize(18),
            .foregroundColor: UIColor.adaptiveTextMain
        ]
    }
    
    @objc func backButtonTapped() {
        print("Нажата кнопка Назад")
    }
        
    @objc func likeButtonTapped() {
        likeButton.toggleLike()
    }
    
    @objc func watchNowButtonTapped() {
        print("Нажата кнопка Watch Now")
    }
}

// MARK: - Constants
private extension MovieDetailViewController {
    enum Constants {
        enum Text {
            static let movieTitle: String = "Luck"
            static let movieDuration: String = "148 Minutes"
            static let movieDate: String = "17 Sep 2021"
            static let movieGenre: String = "Action"
            static let movieDescriptionTitle: String = "Story Line"
            static let movieDescriptionText: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
            static let movieCastTitle: String = "Cast and Crew"
            static let screenTitle: String = "Movie Detail"
            static let watchButtonTitle: String = "Watch now"
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieCastCell.mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCastCell.identifier,
            for: indexPath
        ) as? MovieCastCell else {
            return UICollectionViewCell()
        }
        
        let model = MovieCastCell.mockData[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 144, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
