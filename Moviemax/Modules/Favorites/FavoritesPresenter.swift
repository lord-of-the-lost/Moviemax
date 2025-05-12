//
//  FavoritesPresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

import UIKit

protocol FavoritesPresenterProtocol {
    var state: FavoritesState { get }
    
    func setupView(_ view: FavoritesViewControllerProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(at index: Int)
    func likeButtonTapped(at index: Int)
}

final class FavoritesPresenter {
    private weak var view: FavoritesViewControllerProtocol?
    private let router: FavoritesRouter
    private let movieRepository: MovieRepository
    private var favoriteMovies: [Movie] = []
    
    private(set) var state: FavoritesState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    init(router: FavoritesRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
    }
}

// MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    func setupView(_ view: any FavoritesViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadFavoriteMovies()
    }
    
    func viewWillAppear() {
        loadFavoriteMovies()
    }
    
    func didSelectMovie(at index: Int) {
        guard let movie = favoriteMovies[safe: index] else { return }
        router.showMovieDetails(movie)
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = favoriteMovies[safe: index] else { return }
        
        // Удаляем фильм из избранного
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success:
            loadFavoriteMovies()
        case .failure(let error):
            view?.showAlert(
                title: TextConstants.ChangePass.Errors.errorTitle.localized(),
                message: "\(TextConstants.Favorites.Errors.cantDeleteFromFavorites.localized()) \(error.localizedDescription)"
            )
        }
    }
}

// MARK: - Private Methods
private extension FavoritesPresenter {
    func loadFavoriteMovies() {
        let result = movieRepository.getFavoriteMovies()
        
        switch result {
        case .success(let movies):
            self.favoriteMovies = movies
            
            if movies.isEmpty {
                state = .empty
            } else {
                let viewModels = movies.map { mapMovieToViewModel($0) }
                state = .content(viewModels)
                
                loadImagesForMovies(movies)
            }
            
        case .failure(let error):
            state = .empty
            view?.showAlert(
                title: TextConstants.Common.error.localized(),
                message: "\(TextConstants.Favorites.Errors.cantDownloadFavorites.localized()) \(error.localizedDescription)"
            )
        }
    }
    
    /// Загружает изображения для фильмов и обновляет UI
    func loadImagesForMovies(_ movies: [Movie]) {
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
            isLiked: true
        )
    }
}
