//
//  HomeViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import UIKit

final class HomeViewController: BaseScrollViewController {
    // MARK: - Properties
    private let presenter: HomePresenter
    private var viewModel: HomeViewModel?

    private lazy var userHeaderView = UserHeaderView()
    private lazy var categoryChipsView = ChipsView()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.category
        label.font = AppFont.plusJakartaSemiBold.withSize(14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var seeAllLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.seeAllText, for: .normal)
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
        label.text = Constants.boxOfficeText
        label.font = AppFont.plusJakartaSemiBold.withSize(14)
        label.textColor = .adaptiveTextMain
        return label
    }()
    
    private lazy var posterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset.left = 20
        layout.itemSize = CGSize(width: Constants.Size.cellWidth, height: Constants.Size.cellHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = false
        presenter.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

extension HomeViewController {
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        userHeaderView.configure(with: viewModel.userHeader)
        categoryChipsView.configure(with: viewModel.categories)
        boxOfficeTableView.reloadData()
        posterCollectionView.reloadData()
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
        presenter.didTapMovie(at: indexPath.row)
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
        presenter.didTapMovie(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidthWithSpacing = Constants.Size.cellWidth + Constants.Size.cellSpacing
        let currentItem = Int(targetContentOffset.pointee.x / itemWidthWithSpacing)
        let newHorizontalOffset = CGFloat(currentItem) * itemWidthWithSpacing
        targetContentOffset.pointee = CGPoint(x: newHorizontalOffset, y: 0)
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
        print(#function, "selected: \(value)")
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
    
    func updateTableViewHeight() {
        boxOfficeTableView.snp.remakeConstraints {
            $0.top.equalTo(boxOfficeHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo((viewModel?.boxOfficeMovies.count ?? 0) * 96 + 20)
        }
    }
    
    func setupConstraints() {
        userHeaderView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(userHeaderView.snp.bottom).offset(43)
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
            $0.top.equalTo(categoryChipsView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
        }
    }
    
    @objc func seeAllButtonTapped() {
        
    }
}

// MARK: - Constants
private extension HomeViewController {
    enum Constants {
        static let seeAllText = "See All"
        static let boxOfficeText = "Box Office"
        static let category = "Category"
        
        enum Size {
            static let cellWidth: CGFloat = 300
            static let cellHeight: CGFloat = 280
            static let cellSpacing: CGFloat = 10
        }
    }
}
