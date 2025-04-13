//
//  RecentWatchPresenter.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit

final class RecentWatchPresenter {
    weak var view: RecentWatchViewController?
    private let router: RecentWatchRouter
    private let movieRepository: MovieRepository
    private var recentMovies: [Movie] = []
    
    var state: RecentWatchState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    let genres: [String] = [
        TextConstants.Genres.all.localized(),
        TextConstants.Genres.action.localized(),
        TextConstants.Genres.adventure.localized(),
        TextConstants.Genres.animation.localized(),
        TextConstants.Genres.biography.localized(),
        TextConstants.Genres.drama.localized(),
        TextConstants.Genres.fantasy.localized(),
        TextConstants.Genres.history.localized(),
        TextConstants.Genres.music.localized(),
        TextConstants.Genres.mystery.localized(),
        TextConstants.Genres.romance.localized(),
        TextConstants.Genres.scienceFiction.localized(),
        TextConstants.Genres.thriller.localized(),
        TextConstants.Genres.war.localized(),
        TextConstants.Genres.western.localized(),
    ]
    
    
    init(router: RecentWatchRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
    }
    
    func viewDidLoad() {
        loadRecentWatchMovies()
    }
    
    func viewWillAppear() {
        loadRecentWatchMovies()
    }
    
    func didSelectMovie(at index: Int) {
        guard let movie = recentMovies[safe: index] else { return }
        router.showMovieDetails(movie)
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = recentMovies[safe: index] else { return }
        
        // Переключаем статус избранного для фильма
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            recentMovies[index].isFavorite = isFavorite
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось обновить статус избранного: \(error.localizedDescription)"
            )
        }
    }
    
    func removeFromRecentWatch(at index: Int) {
        guard let movie = recentMovies[safe: index] else { return }
        
        // Удаляем фильм из недавно просмотренных
        let result = movieRepository.removeFromRecentlyWatched(movie: movie)
        
        switch result {
        case .success:
            loadRecentWatchMovies()
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось удалить фильм из недавно просмотренных: \(error.localizedDescription)"
            )
        }
    }
}

// MARK: - Private Methods
private extension RecentWatchPresenter {
    func loadRecentWatchMovies() {
        let result = movieRepository.getRecentlyWatchedMovies()
        
        switch result {
        case .success(let movies):
            self.recentMovies = movies
            
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
                title: "Ошибка",
                message: "Не удалось загрузить недавно просмотренные фильмы: \(error.localizedDescription)"
            )
        }
    }
    
    /// Преобразует модель фильма в модель ячейки
    func mapMovieToViewModel(_ movie: Movie) -> MovieLargeCell.MovieLargeCellViewModel {
        let result = movieRepository.isFavorite(movie: movie)
        
        let isLiked: Bool
        switch result {
        case .success(let liked):
            isLiked = liked
        case .failure:
            isLiked = false
        }
        
        return MovieLargeCell.MovieLargeCellViewModel(
            title: movie.name,
            poster: UIImage(resource: .posterPlaceholder),
            filmLength: "\(movie.movieLength) Minutes",
            reliseDate: movie.premiere.world,
            genre: movie.genres.first?.name ?? "Unknown",
            isLiked: isLiked
        )
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
}
