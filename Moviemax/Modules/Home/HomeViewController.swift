//
//  HomeViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func configure(with viewModel: HomeViewModel)
    func updateUserHeader(with userHeader: UserHeaderView.UserHeaderViewModel)
    func updateSliderSection(with sliderMovies: [PosterCell.PosterCellViewModel])
    func updateBoxOfficeSection(with boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel])
    func updateBoxOfficeItem(at index: Int, with model: MovieSmallCell.MovieSmallCellViewModel)
    func hideLoadingIndicator()
    func showLoadingIndicator()
    func showAlert(title: String, message: String?)
}

final class HomeViewController: BaseScrollViewController {
    private let presenter: HomePresenter
    private var viewModel: HomeViewModel?
    private var didScrollToInitialIndex = false

    private lazy var userHeaderView = UserHeaderView()
    private lazy var categoryChipsView = ChipsView()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Home.category.localized()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextConstants.Home.seeAllText.localized(), for: .normal)
        button.titleLabel?.font = AppFont.plusJakartaRegular.withSize(16)
        button.setTitleColor(.accent, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var boxOfficeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.isScrollEnabled = false
        tableView.register(MovieSmallCell.self, forCellReuseIdentifier: MovieSmallCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var boxOfficeHeaderView: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Home.boxOfficeText.localized()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var posterCollectionView: UICollectionView = {
        let layout = CarouselFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
        changeInitialItemIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = false
        presenter.viewWillAppear()
        updateLocalizedTexts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        setupActivityIndicator()
        showLoadingIndicator()
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        userHeaderView.configure(with: viewModel.userHeader)
        categoryChipsView.configure(with: viewModel.categories)
        posterCollectionView.reloadData()
        boxOfficeTableView.reloadData()
    }
    
    // Метод для обновления только заголовка с пользовательскими данными
    func updateUserHeader(with userHeader: UserHeaderView.UserHeaderViewModel) {
        guard var viewModel = self.viewModel else { return }
        viewModel.userHeader = userHeader
        self.viewModel = viewModel
        userHeaderView.configure(with: userHeader)
    }
    
    // Метод для обновления только слайдера с фильмами
    func updateSliderSection(with sliderMovies: [PosterCell.PosterCellViewModel]) {
        guard var viewModel = self.viewModel else { return }
        viewModel.sliderMovies = sliderMovies
        self.viewModel = viewModel
        posterCollectionView.reloadData()
    }
    
    // Метод для обновления только секции boxOffice
    func updateBoxOfficeSection(with boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel]) {
        guard var viewModel = self.viewModel else { return }
        viewModel.boxOfficeMovies = boxOfficeMovies
        self.viewModel = viewModel
        updateTableViewHeight()
        boxOfficeTableView.reloadData()
    }
    
    // Метод для обновления конкретной ячейки в boxOffice
    func updateBoxOfficeItem(at index: Int, with model: MovieSmallCell.MovieSmallCellViewModel) {
        guard var viewModel = self.viewModel, index < viewModel.boxOfficeMovies.count else { return }
        
        viewModel.boxOfficeMovies[index] = model
        self.viewModel = viewModel
        
        // Обновляем только видимую ячейку, если она видна
        if let cell = boxOfficeTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MovieSmallCell {
            cell.configure(with: model)
        }
    }
    
    func hideLoadingIndicator() {
        // TODO: тут костыль в виде таймера, не нашла правильного момента чтобы вызвать этот метод, когда картинки уже загрузились
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.activityIndicator.stopAnimating()
            self.contentView.isHidden = false
        }
    }
    
    func showLoadingIndicator() {
        contentView.isHidden = true
        activityIndicator.startAnimating()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.boxOfficeMovies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieSmallCell.identifier, for: indexPath) as? MovieSmallCell,
            let model = viewModel?.boxOfficeMovies[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapBoxOfficeMovie(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.sliderMovies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as? PosterCell,
            let model = viewModel?.sliderMovies[safe: indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapSliderMovie(at: indexPath.row)
    }
}

// MARK: - MovieSmallCellDelegate
extension HomeViewController: MovieSmallCellDelegate {
    func likeTapped(_ cell: MovieSmallCell) {
        guard let index = boxOfficeTableView.indexPath(for: cell)?.row else { return }
        presenter.likeButtonTapped(at: index)
    }
}

// MARK: - ChipsViewDelegate
extension HomeViewController: ChipsViewDelegate {
    func chipsView(_ chipsView: ChipsView, didSelectItemAt index: Int, value: String) {
        presenter.didSelectGenre(value)
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .appBackground
        contentView.addSubviews(
            userHeaderView,
            posterCollectionView,
            categoryLabel,
            seeAllButton,
            categoryChipsView,
            boxOfficeHeaderView,
            boxOfficeTableView
        )
        categoryChipsView.delegate = self
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateTableViewHeight() {
        boxOfficeTableView.snp.remakeConstraints {
            $0.top.equalTo(boxOfficeHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo((viewModel?.boxOfficeMovies.count ?? 0) * 96)
        }
    }
    
    func changeInitialItemIfNeeded() {
        if !didScrollToInitialIndex,
           posterCollectionView.numberOfItems(inSection: 0) > 1 {
            didScrollToInitialIndex = true
            scrollToInitialItem()
        }
    }
    
    func scrollToInitialItem() {
        let targetIndex = IndexPath(item: 1, section: 0) // the second cell
        posterCollectionView.scrollToItem(at: targetIndex, at: .centeredHorizontally, animated: false)
    }
    
    func updateLocalizedTexts() {
        seeAllButton.setTitle(TextConstants.Home.seeAllText.localized(), for: .normal)
        boxOfficeHeaderView.text = TextConstants.Home.boxOfficeText.localized()
        categoryLabel.text = TextConstants.Home.category.localized()
    }
    
    func setupConstraints() {
        userHeaderView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(userHeaderView.snp.bottom).offset(33)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(290)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(posterCollectionView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(24)
        }
  
        categoryChipsView.snp.makeConstraints { 
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        boxOfficeHeaderView.snp.makeConstraints { 
            $0.top.equalTo(categoryChipsView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(24)
        }
        
        seeAllButton.snp.makeConstraints {
            $0.top.equalTo(categoryChipsView.snp.bottom).offset(18)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc func seeAllButtonTapped() {
        presenter.showAllMovies()
    }
}
