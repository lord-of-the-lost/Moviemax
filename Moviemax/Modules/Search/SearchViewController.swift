//
//  SearchViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

// MARK: - State
enum SearchState {
    case empty
    case content([MovieLargeCell.MovieLargeCellViewModel])
}

final class SearchViewController: UIViewController {
    
    // MARK: Properties
    private let presenter: SearchPresenter
    
    private lazy var searhView = SearchFieldView()
    
    private lazy var chipsView: ChipsView = {
        let view = ChipsView(items: presenter.genres)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .appBackground
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
        label.text = Constants.Text.emptyStateTitle
        label.font = AppFont.plusJakartaBold.withSize(24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emptyStateDescription: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.emptyStateDescription
        label.font = AppFont.montserratMedium.withSize(16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Init
    init(presenter: SearchPresenter) {
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
        presenter.view = self
        setupUI()
        presenter.viewDidLoad()
        chipsView.delegate = self
    }

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
        Constants.Constraints.cellHeight
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

// MARK: - Private methods
private extension SearchViewController {
    func setupUI() {
        navigationItem.title = Constants.Text.screenTitle
        view.backgroundColor = .appBackground
        view.addSubviews(searhView, chipsView, tableView, emptyStateView)
        emptyStateView.addSubviews(emptyStateLabel, emptyStateDescription)
        setupConstraints()
        
        searhView.rightButtonAction = { [weak self] in
            self?.presenter.filterButtonTapped()
        }
    }
    
    func setupConstraints() {
        
        searhView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Constraints.smallOffset)
            $0.leading.equalTo(Constants.Constraints.contentInset)
            $0.trailing.equalTo(Constants.Constraints.contentInset.negative)
            $0.height.equalTo(Constants.Constraints.searchFieldHeight)
        }
        
        chipsView.snp.makeConstraints {
            $0.top.equalTo(searhView.snp.bottom).offset(Constants.Constraints.topOffset)
            $0.leading.equalTo(Constants.Constraints.contentInset)
            $0.trailing.equalTo(Constants.Constraints.contentInset.negative)
            $0.height.equalTo(Constants.Constraints.chipsViewHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(chipsView.snp.bottom).offset(Constants.Constraints.topOffset)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(Constants.Constraints.contentInset)
            $0.trailing.equalTo(Constants.Constraints.contentInset.negative)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.Constraints.contentInset)
        }
        
        emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        emptyStateDescription.snp.makeConstraints {
            $0.top.equalTo(emptyStateLabel.snp.bottom).offset(Constants.Constraints.emptyStateSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: ChipsViewDelegate {
    func chipsView(_ chipsView: ChipsView, didSelectItemAt index: Int, value: String) {
        print(#function, "selected: \(value)")
    }
}

// MARK: - Constants
private extension SearchViewController {
    enum Constants {
        enum Text {
            static let screenTitle = "Search"
            static let emptyStateTitle = "You haven't seen any movies yet."
            static let emptyStateDescription = "Movies that you have watched recently will appear here."
        }
        enum Constraints {
            static let searchFieldHeight: CGFloat = 52
            static let cellHeight: CGFloat = 184
            static let emptyStateSpacing: CGFloat = 16
            static let contentInset: CGFloat = 22
            static let chipsViewHeight: CGFloat = 34
            static let topOffset: CGFloat = 24
            static let smallOffset: CGFloat = 8
        }
    }
}
