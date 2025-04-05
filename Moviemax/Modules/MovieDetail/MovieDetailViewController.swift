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
    private let model: MovieDetailModel
    
    private lazy var contentView: UIView = UIView()
    private lazy var movieRatingView: RatingView = RatingView(rating: 3.5)
    private lazy var movieDescriptionDetail: DescriptionDetail = DescriptionDetail(text: model.descriptionText)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var movieImageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: .posterPlaceholder))
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = model.title
        label.textAlignment = .center
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(24)
        return label
    }()
    
    private lazy var movieDateView = MovieDetailView(text: model.date,
                                                     image: UIImage(resource: .calendar))
    
    private lazy var movieDurationView = MovieDetailView(text: model.duration,
                                                         image: UIImage(resource: .clock))
    
    private lazy var movieGenreView = MovieDetailView(text: model.genre,
                                                      image: UIImage(resource: .clock))

    private lazy var movieDescriptionTitle: UILabel = {
        let label = UILabel()
        label.text = model.descriptionTitle
        label.textAlignment = .left
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        return label
    }()
        
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
        view.backgroundColor = .appBackground
        return view
    }()
    
    private lazy var watchButton: CommonButton = {
        let button = CommonButton(title: Constants.Text.watchButtonTitle)
        button.addTarget(self, action: #selector(watchNowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .arrowBack), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: LikeButton = {
        let likeButton = LikeButton()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    init(presenter: MovieDetailPresenter, model: MovieDetailModel) {
        self.presenter = presenter
        self.model = model
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
        view.backgroundColor = .appBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            movieImageView,
            movieTitleLabel,
            movieDurationView,
            movieDateView,
            movieGenreView,
            movieRatingView,
            movieDescriptionTitle,
            movieDescriptionDetail,
            movieCastTitle,
            castCollectionView
        )
        
        view.addSubview(watchButtonView)
        watchButtonView.addSubview(watchButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        watchButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(101)
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
        
        watchButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(56)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func setupNavigation() {
        self.title = Constants.Text.screenTitle
                
        backButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
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
            static let movieCastTitle: String = "Cast and Crew"
            static let screenTitle: String = "Movie Detail"
            static let watchButtonTitle: String = "Watch now"
        }
    }
}


// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MovieCastCell.mockData.count
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
        CGSize(width: 144, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
