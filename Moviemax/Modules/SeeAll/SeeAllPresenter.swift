//
//  SeeAllPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

import UIKit

protocol SeeAllPresenterProtocol {
    var state: SeeAllState { get }
    
    func setupView(_ view: SeeAllViewControllerProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(at index: Int)
    func backButtonTapped()
    func likeButtonTapped(at index: Int)
}

// MARK: - State
enum SeeAllState {
    case empty
    case loading
    case content([MovieLargeCell.MovieLargeCellViewModel])
}

final class SeeAllPresenter {
    private weak var view: SeeAllViewControllerProtocol?
    private let router: SeeAllRouter
    private let movieRepository: MovieRepository
    private var allMovies: [Movie] = []
    private var isFirstScreenLaunch = true
    
    var state: SeeAllState = .loading {
        didSet {
            view?.show(state)
        }
    }
    
    init(router: SeeAllRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
    }
}

// MARK: - SeeAllPresenterProtocol
extension SeeAllPresenter: SeeAllPresenterProtocol {
    func setupView(_ view: SeeAllViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadMovies()
    }
    
    func viewWillAppear() {
        if isFirstScreenLaunch {
            isFirstScreenLaunch = false
        } else {
            checkFavoriteStatus(for: allMovies)
        }
    }
    
    func didSelectMovie(at index: Int) {
        guard let movie = allMovies[safe: index] else { return }
        router.showMovieDetails(movie)
    }
    
    func backButtonTapped() {
        router.navigateToBack()
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = allMovies[safe: index] else { return }
        
        // Переключаем статус избранного для фильма
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            allMovies[index].isFavorite = isFavorite
            
            // Обновляем только статус лайка в модели представления
            if case .content(var viewModels) = state, index < viewModels.count {
                viewModels[index].isLiked = isFavorite
                state = .content(viewModels)
            }
            
        case .failure(let error):
            view?.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Favorites.Errors.couldntUpdateFavoritesStatus.localized() + error.localizedDescription
            )
        }
    }
}

// MARK: - Private Methods
private extension SeeAllPresenter {
    func loadMovies() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result = movieRepository.getPopularMovies()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.allMovies = movies
                    self.checkFavoriteStatus(for: movies)
                    
                case .failure(let error):
                    self.state = .empty
                    self.view?.showAlert(
                        title: TextConstants.Auth.Errors.errorTitle.localized(),
                        message: TextConstants.SeeAll.couldntDownloadMovies.localized() + error.localizedDescription
                    )
                }
            }
        }
    }
    
    /// Загружает изображения для фильмов и обновляет UI
    private func loadImagesForMovies(_ movies: [Movie]) {
        for (index, movie) in movies.enumerated() {
            guard !movie.poster.url.isEmpty else { continue }
            
            movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            self.updateMovieImage(at: index, with: image)
                        }
                    case .failure:
                        // В случае ошибки оставляем изображение-заглушку
                        break
                    }
                }
            }
        }
    }
    
    /// Обновляет изображение в модели и UI
    func updateMovieImage(at index: Int, with image: UIImage) {
        guard case .content(var viewModels) = state, index < viewModels.count else {
            return
        }
        
        viewModels[index].poster = image
        
        state = .content(viewModels)
    }
    
    /// Преобразует модель фильма в модель ячейки
    func mapMovieToViewModel(_ movie: Movie) -> MovieLargeCell.MovieLargeCellViewModel {
        MovieLargeCell.MovieLargeCellViewModel(
            title: movie.name,
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "\(movie.movieLength) \(TextConstants.Favorites.minutes.localized())",
            reliseDate: movie.premiere.world,
            genre: movie.genres.first?.name ?? "Unknown",
            isLiked: movie.isFavorite
        )
    }
    
    /// Проверяет статус избранного для фильмов
    func checkFavoriteStatus(for movies: [Movie]) {
        var updatedMovies = movies
        let group = DispatchGroup()
        
        for (index, movie) in movies.enumerated() {
            group.enter()
            let result = movieRepository.isFavorite(movie: movie)
            
            switch result {
            case .success(let isFavorite):
                updatedMovies[index].isFavorite = isFavorite
            case .failure:
                break
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.allMovies = updatedMovies
            
            let viewModels = updatedMovies.map { self.mapMovieToViewModel($0) }
            self.state = .content(viewModels)
            
            self.loadImagesForMovies(updatedMovies)
        }
    }
}
