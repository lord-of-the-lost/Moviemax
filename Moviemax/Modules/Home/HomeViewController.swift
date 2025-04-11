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
    
    private lazy var filmCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
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
        boxOfficeTableView.snp.remakeConstraints {
            $0.top.equalTo(boxOfficeHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo((viewModel?.boxOfficeMovies.count ?? 0) * 96 + 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
        
        //MOCK
        userHeaderView.configure(
            with: UserHeaderView.UserHeaderViewModel(
                greeting: "Hi, Andy",
                status: "only streaming movie lovers",
                avatar: .avatar
            )
        )
        categoryChipsView.configure(
            with: [
                "All",
                "Action",
                "Adventure",
                "Animation",
                "Biography",
                "Comedy",
                "Drama",
                "Fantasy",
                "History",
                "Horror",
                "Music",
                "Romance",
                "Science Fiction",
                "Thriller",
                "War",
                "Western"
            ]
        )
    }
}

extension HomeViewController {
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        userHeaderView.configure(with: viewModel.userHeader)
        categoryChipsView.configure(with: viewModel.categories)
        boxOfficeTableView.reloadData()
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
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

// MARK: - MovieSmallCellDelegate

extension HomeViewController: MovieSmallCellDelegate {
    func likeTapped(_ cell: MovieSmallCell) {
        
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
        navigationController?.navigationBar.isHidden = true
        contentView.addSubviews(
            userHeaderView,
            filmCellView,
            categoryLabel,
            seeAllButton,
            categoryChipsView,
            boxOfficeHeaderView,
            boxOfficeTableView
        )
        categoryChipsView.delegate = self
    }

    
    func setupConstraints() {
        userHeaderView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        filmCellView.snp.makeConstraints {
            $0.top.equalTo(userHeaderView.snp.bottom).offset(43)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(290)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(filmCellView.snp.bottom).offset(60)
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
    }
}
