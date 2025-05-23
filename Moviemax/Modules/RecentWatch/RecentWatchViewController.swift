//
//  RecentWatchViewController.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit

protocol RecentWatchViewControllerProtocol: AnyObject {
    func show(_ state: RecentWatchState)
    func updateGenres(_ genres: [String])
    func showAlert(title: String, message: String?)
}

// MARK: - State
enum RecentWatchState {
    case empty
    case content([MovieLargeCell.MovieLargeCellViewModel])
}

final class RecentWatchViewController: UIViewController {
    private let presenter: RecentWatchPresenterProtocol
    
    private lazy var chipsView = ChipsView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .appBackground
        tableView.register(MovieLargeCell.self, forCellReuseIdentifier: MovieLargeCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstants.RecentWatch.emptyStateTitle.localized()
        label.font = AppFont.plusJakartaBold.withSize(24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emptyStateDescription: UILabel = {
        let label = UILabel()
        label.text = TextConstants.RecentWatch.emptyStateDescription.localized()
        label.font = AppFont.montserratMedium.withSize(16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Init
    init(presenter: RecentWatchPresenterProtocol) {
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
        setupUI()
        presenter.viewDidLoad()
        chipsView.delegate = self
        chipsView.configure(with: presenter.genres)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.tabBarController?.tabBar.isHidden = false
        presenter.viewWillAppear()
        updateLocalizedTexts()
    }
}

// MARK: - RecentWatchViewControllerProtocol
extension RecentWatchViewController: RecentWatchViewControllerProtocol {
    func show(_ state: RecentWatchState) {
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
    
    func updateGenres(_ genres: [String]) {
        chipsView.configure(with: genres)
        
        // Получаем текущий выбранный жанр из презентера
        let selectedGenre = presenter.getSelectedGenre()
        
        // Находим индекс выбранного жанра в обновленном списке
        if let index = genres.firstIndex(of: selectedGenre) {
            chipsView.selectItem(at: index)
        } else if !genres.isEmpty {
            // Если жанр не найден, выбираем первый жанр (обычно "All")
            chipsView.selectItem(at: 0)
        }
    }
}

// MARK: - UITableViewDataSource
extension RecentWatchViewController: UITableViewDataSource {
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
extension RecentWatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            self?.presenter.removeFromRecentWatch(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - MovieLargeCellDelegate
extension RecentWatchViewController: MovieLargeCellDelegate {
    func likeTapped(_ cell: MovieLargeCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        presenter.likeButtonTapped(at: index)
    }
}

// MARK: - ChipsViewDelegate
extension RecentWatchViewController: ChipsViewDelegate {
    func chipsView(_ chipsView: ChipsView, didSelectItemAt index: Int, value: String) {
        presenter.didSelectGenre(at: index, value: value)
    }
}

// MARK: - Private methods
private extension RecentWatchViewController {
    func setupUI() {
        navigationItem.title = TextConstants.RecentWatch.screenTitle.localized()
        view.backgroundColor = .appBackground
        view.addSubviews(chipsView, tableView, emptyStateView)
        emptyStateView.addSubviews(emptyStateLabel, emptyStateDescription)
        setupConstraints()
    }
    
    func setupConstraints() {
        chipsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalTo(22)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(chipsView.snp.bottom).offset(24)
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
    }
    
    func updateLocalizedTexts() {
        navigationItem.title = TextConstants.RecentWatch.screenTitle.localized()
        emptyStateDescription.text = TextConstants.RecentWatch.emptyStateDescription.localized()
        emptyStateLabel.text = TextConstants.RecentWatch.emptyStateTitle.localized()
    }
}
