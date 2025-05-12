//
//  SearchViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func show(_ state: SearchState)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showAlert(title: String, message: String?)
}

// MARK: - State
enum SearchState {
    case empty
    case content([MovieLargeCell.MovieLargeCellViewModel])
}

final class SearchViewController: UIViewController {
    private let presenter: SearchPresenterProtocol
    
    private lazy var searchView: SearchFieldView = {
        let view = SearchFieldView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .appBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MovieLargeCell.self, forCellReuseIdentifier: MovieLargeCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Search.emptyStateTitle.localized()
        label.font = AppFont.plusJakartaBold.withSize(24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emptyStateDescription: UILabel = {
        let label = UILabel()
        label.text = TextConstants.Search.emptyStateDescription.localized()
        label.font = AppFont.montserratMedium.withSize(16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .accent
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: Init
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        setupView()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        updateLocalizedTexts()
        presenter.viewWillAppear()
    }
}

// MARK: - SearchViewControllerProtocol
extension SearchViewController: SearchViewControllerProtocol {
    func show(_ state: SearchState) {
        switch state {
        case .empty:
            tableView.isHidden = true
            emptyStateView.isHidden = false
        case .content:
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()
        }
    }
    
    func showLoadingIndicator() {
        tableView.isHidden = true
        emptyStateView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .content(let movies) = presenter.state {
            return movies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            case .content(let movies) = presenter.state,
            let model = movies[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieLargeCell.identifier,
                for: indexPath
            ) as? MovieLargeCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath.row)
    }
}

// MARK: - MovieLargeCellDelegate
extension SearchViewController: MovieLargeCellDelegate {
    func likeTapped(_ cell: MovieLargeCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        presenter.likeButtonTapped(at: index)
    }
}

// MARK: - SearchFieldViewDelegate
extension SearchViewController: SearchFieldViewDelegate {
    func filterButtonTapped() {
        presenter.filterButtonTapped()
    }
    
    func searchFieldTextChanged(_ searchField: SearchFieldView, text: String) {
        presenter.searchTextChanged(text)
    }
}

// MARK: - Private methods
private extension SearchViewController {
    func setupView() {
        navigationItem.title = TextConstants.Search.screenTitle.localized()
        view.backgroundColor = .appBackground
        view.addSubviews(searchView, tableView, emptyStateView, activityIndicator)
        emptyStateView.addSubviews(emptyStateLabel, emptyStateDescription)
    }
    
    func setupConstraints() {
        searchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalTo(22)
            $0.trailing.equalTo(-22)
            $0.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(24)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(22)
            $0.trailing.equalTo(-22)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        emptyStateDescription.snp.makeConstraints {
            $0.top.equalTo(emptyStateLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateLocalizedTexts() {
        navigationItem.title = TextConstants.Search.screenTitle.localized()
        emptyStateLabel.text = TextConstants.Search.emptyStateTitle.localized()
        emptyStateDescription.text = TextConstants.Search.emptyStateDescription.localized()
    }
}
