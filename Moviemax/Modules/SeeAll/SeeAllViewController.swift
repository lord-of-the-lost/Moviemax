//
//  SeeAllViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

import UIKit

protocol SeeAllViewControllerProtocol: AnyObject {
    func show(_ state: SeeAllState)
    func hideActivityIndicator()
    func showActivityIndicator()
    func setupActivityIndicator()
    func showAlert(title: String, message: String?)
}

final class SeeAllViewController: UIViewController {
    private let presenter: SeeAllPresenterProtocol
    
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
        label.text = TextConstants.SeeAll.emptyStateTitle.localized()
        label.font = AppFont.plusJakartaBold.withSize(24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emptyStateDescription: UILabel = {
        let label = UILabel()
        label.text = TextConstants.SeeAll.emptyStateDescription.localized()
        label.font = AppFont.montserratMedium.withSize(16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .arrowBack), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(presenter: SeeAllPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        setupView()
        setupConstraints()
        setupNavigation()
        setupActivityIndicator()
        showActivityIndicator()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.tabBarController?.tabBar.isHidden = false
        presenter.viewWillAppear()
        updateLocalizedTexts()
    }
}

// MARK: - SeeAllViewControllerProtocol
extension SeeAllViewController: SeeAllViewControllerProtocol {
    func show(_ state: SeeAllState) {
        switch state {
        case .empty:
            hideActivityIndicator()
            tableView.isHidden = true
            emptyStateView.isHidden = false
        case .loading:
            showActivityIndicator()
        case .content:
            hideActivityIndicator()
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()
        }
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        emptyStateView.isHidden = true
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension SeeAllViewController: UITableViewDataSource {
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
extension SeeAllViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath.row)
    }
}

// MARK: - MovieLargeCellDelegate
extension SeeAllViewController: MovieLargeCellDelegate {
    func likeTapped(_ cell: MovieLargeCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        presenter.likeButtonTapped(at: index)
    }
}

// MARK: - Private Methods
private extension SeeAllViewController {
    func setupView() {
        view.backgroundColor = .appBackground
        view.addSubviews(tableView, emptyStateView)
        emptyStateView.addSubviews(emptyStateLabel, emptyStateDescription)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
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
    
    func setupNavigation() {
        self.title = TextConstants.SeeAll.screenTitle.localized()
                
        backButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: AppFont.montserratBold.withSize(18),
            .foregroundColor: UIColor.adaptiveTextMain
        ]
    }
    
    func updateLocalizedTexts() {
        self.title = TextConstants.SeeAll.screenTitle.localized()
        emptyStateLabel.text = TextConstants.SeeAll.emptyStateTitle.localized()
        emptyStateDescription.text = TextConstants.SeeAll.emptyStateDescription.localized()
    }
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
}
