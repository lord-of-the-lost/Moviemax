//
//  MovieDetailPresenter.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit

final class MovieDetailPresenter {
    weak var view: MovieDetailViewController?
    private let router: MovieDetailRouter
    private let movieRepository: MovieRepository
    private var model: Movie
    
    init(router: MovieDetailRouter, dependency: DI, model: Movie) {
        self.router = router
        self.model = model
        self.movieRepository = dependency.movieRepository
    }
    
    func backButtonTapped() {
        router.closeMovieDetailScreen()
    }
    
    func viewDidLoad() {
        setupView(with: model)
        addToRecentWatch()
    }
    
    func openURLTapped() {
        guard let url = URL(string: model.trailerURL) else { return }
        UIApplication.shared.open(url)
    }
    
    func likeButtonTapped() {
        var movie = model
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            movie.isFavorite = isFavorite
            model = movie
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось обновить статус избранного: \(error.localizedDescription)"
            )
        }
    }
    
    func getPersonsCount() -> Int {
        return model.persons.count
    }
    
    func getPersonViewModel(at index: Int) -> MovieCastCell.MovieCastCellViewModel {
        guard let person = model.persons[safe: index] else {
            return MovieCastCell.MovieCastCellViewModel(
                castImage: UIImage(resource: .avatar),
                castName: "Unknown",
                castDescription: "Unknown"
            )
        }
        
        return MovieCastCell.MovieCastCellViewModel(
            castImage: UIImage(resource: .avatar),
            castName: person.name,
            castDescription: person.profession
        )
    }
}

private extension MovieDetailPresenter {
    func setupView(with model: Movie) {
        map(model) { [weak self] viewModel in
            self?.view?.configure(with: viewModel)
        }
    }
    
    func map(_ model: Movie, completion: @escaping (MovieDetailModel) -> Void) {
        let result = movieRepository.isFavorite(movie: model)
        
        let isLiked: Bool
        switch result {
        case .success(let liked):
            isLiked = liked
        case .failure:
            isLiked = false
        }
        
        loadMovieImage(for: model) { image in
            let detailModel = MovieDetailModel(
                title: model.name,
                image: image,
                duration: "\(model.movieLength.formatted()) \(TextConstants.Favorites.minutes.localized())",
                date: model.premiere.world,
                genre: model.genres.first?.name ?? "Unknown",
                rating: model.rating.value,
                descriptionText: model.description,
                isFavorite: isLiked,
                persons: model.persons
            )
            completion(detailModel)
        }
    }

    func loadMovieImage(for movie: Movie, completion: @escaping (UIImage) -> Void) {
        guard !movie.poster.url.isEmpty else {
            completion(UIImage(resource: .posterPlaceholder))
            return
        }
        
        movieRepository.loadImage(from: movie.poster.url) { result in
            switch result {
            case .success(let imageData):
                if let movieImage = UIImage(data: imageData) {
                    completion(movieImage)
                } else {
                    completion(UIImage(resource: .posterPlaceholder))
                }
            case .failure:
                completion(UIImage(resource: .posterPlaceholder))
            }
        }
    }
    
    private func addToRecentWatch() {
        let result = movieRepository.addToRecentlyWatched(movie: model)
        
        if case .failure(let error) = result {
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось добавить фильм в недавно просмотренные: \(error.localizedDescription)"
            )
        }
    }
}
