//
//  SeeAllPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 12.04.2025.
//

import UIKit

final class SeeAllPresenter {
    weak var view: SeeAllViewController?
    private let router: SeeAllRouter
    private let movieRepository: MovieRepository
    private var allMovies: [Movie] = []
    
    var state: SeeAllState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    init(router: SeeAllRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
    }
    
    func viewDidLoad() {
        loadMovies()
    }
    
    func viewWillAppear() {
        loadMovies()
    }
    
    func didSelectMovie(at index: Int) {
        guard let movie = allMovies[safe: index] else { return }
        router.showMovieDetails(movie)
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = allMovies[safe: index] else { return }
        
        // Удаляем фильм из избранного
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success:
            loadMovies()
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось удалить фильм из избранного: \(error.localizedDescription)"
            )
        }
    }
    
    func backButtonTapped() {
        router.navigateToBack()
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
                    
                    if movies.isEmpty {
                        self.state = .empty
                    } else {
                        let viewModels = movies.map { self.mapMovieToViewModel($0) }
                        self.state = .content(viewModels)
                        
                        self.loadImagesForMovies(movies)
                    }
                    
                case .failure(let error):
                    self.state = .empty
                    self.view?.showAlert(
                        title: "Ошибка",
                        message: "Не удалось загрузить фильмы: \(error.localizedDescription)"
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
            filmLength: "\(movie.movieLength) Minutes",
            reliseDate: movie.premiere.world,
            genre: movie.genres.first?.name ?? "Unknown",
            isLiked: movie.isFavorite
        )
    }
}
