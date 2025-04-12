//
//  HomePresenter.swift
//  Moviemax
//
//  Created by Николай Игнатов on 10.04.2025.
//

import Foundation
import UIKit

final class HomePresenter {
    // MARK: - Properties
    weak var view: HomeViewController?
    private var movies: [Movie] = []
    private var viewModel: HomeViewModel?
    private let router: HomeRouter
    private let movieRepository: MovieRepository
    private let userService: UserService
  
    init(router: HomeRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
        self.userService = dependency.userService
    }
    
    func viewDidLoad() {
        loadPopularMovies()
    }
    
    func viewWillAppear() {
        loadUserData()
        checkFavoriteStatus(for: movies)
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = movies[safe: index] else { return }
        
        // Переключаем статус избранного для фильма
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            movies[index].isFavorite = isFavorite
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось обновить статус избранного: \(error.localizedDescription)"
            )
        }
    }
    
    func didTapMovie(at index: Int) {
        guard let movie = movies[safe: index] else { return }
        router.showMovieDetails(movie: movie)
    }
}

// MARK: - Private Methods
private extension HomePresenter {
    func loadUserData() {
        guard let currentUser = userService.getCurrentUser() else { return }
        
        let avatar = currentUser.avatar.flatMap { UIImage(data: $0) } ?? UIImage(resource: .avatar)
        let viewModel = UserHeaderView.UserHeaderViewModel(
            greeting: "Hi, \(currentUser.firstName)",
            status: "only streaming movie lovers",
            avatar: avatar
        )
        
        updateViewModel(userHeader: viewModel)
    }
    
    func loadPopularMovies() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result = movieRepository.getPopularMovies()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.processMovies(movies)
                    self.checkFavoriteStatus(for: movies)
                case .failure(let error):
                    self.view?.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    /// Проверяет статус избранного для списка фильмов
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
            self.movies = updatedMovies
            self.processMovies(updatedMovies)
        }
    }
    
    func processMovies(_ movies: [Movie]) {
        // Преобразуем модель Movie для карусели фильмов
        let sliderMovies = movies.map { mapMovieToPosterCellViewModel($0) }
        
        // Преобразуем модель Movie для секции Box Office
        let boxOfficeMovies = movies.map { mapMovieToMovieSmallCellViewModel($0) }
        
        // Формируем категории фильмов на основе жанров
        let categories = ["All"] + extractUniqueCategories(from: movies)
        
        // Обновляем вью модель
        updateViewModel(
            sliderMovies: sliderMovies,
            boxOfficeMovies: boxOfficeMovies,
            categories: categories
        )
        
        // Загружаем изображения для фильмов
        loadMovieImages(for: movies)
    }
    
    func updateViewModel(
        userHeader: UserHeaderView.UserHeaderViewModel? = nil,
        sliderMovies: [PosterCell.PosterCellViewModel]? = nil,
        boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel]? = nil,
        categories: [String]? = nil
    ) {
        // Получаем текущую модель или создаем новую
        if viewModel == nil {
            viewModel = HomeViewModel(
                userHeader: UserHeaderView.UserHeaderViewModel(
                    greeting: "Hi, User",
                    status: "only streaming movie lovers",
                    avatar: UIImage(resource: .avatar)
                ),
                sliderMovies: [],
                categories: [],
                boxOfficeMovies: []
            )
        }
        
        guard var viewModel else { return }
        
        if let userHeader = userHeader {
            viewModel.userHeader = userHeader
        }
        
        if let sliderMovies = sliderMovies {
            viewModel.sliderMovies = sliderMovies
        }
        
        if let boxOfficeMovies = boxOfficeMovies {
            viewModel.boxOfficeMovies = boxOfficeMovies
        }
        
        if let categories = categories {
            viewModel.categories = categories
        }
        
        self.viewModel = viewModel
        view?.configure(with: viewModel)
    }
    
    /// Метод для извлечения уникальных категорий из фильмов
    func extractUniqueCategories(from movies: [Movie]) -> [String] {
        let allGenres = movies.flatMap { $0.genres.map { $0.name } }
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return uniqueGenres
    }
    
    /// Метод для преобразования Movie в PosterCell.PosterCellViewModel
    func mapMovieToPosterCellViewModel(_ movie: Movie) -> PosterCell.PosterCellViewModel {
        return PosterCell.PosterCellViewModel(
            title: movie.name,
            category: movie.genres.first?.name ?? "Unknown",
            image: UIImage(resource: .posterPlaceholder)
        )
    }
    
    /// Метод для преобразования Movie в MovieSmallCell.MovieSmallCellViewModel
    func mapMovieToMovieSmallCellViewModel(_ movie: Movie) -> MovieSmallCell.MovieSmallCellViewModel {
        return MovieSmallCell.MovieSmallCellViewModel(
            title: movie.name,
            poster: UIImage(resource: .posterPlaceholder), // Заглушка, будет заменена после загрузки изображения
            filmLength: "\(movie.movieLength) Minutes",
            genre: movie.genres.first?.name ?? "Unknown",
            rating: String(format: "%.1f", movie.rating.value),
            voiceCount: "(\(movie.rating.votesCount))",
            isLiked: movie.isFavorite // Используем текущий статус избранного
        )
    }
    
    // Метод для загрузки изображений фильмов
    func loadMovieImages(for movies: [Movie]) {
        for (index, movie) in movies.enumerated() {
            if !movie.poster.url.isEmpty {
                movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            self.updateMovieImage(at: index, with: image)
                        }
                    case .failure:
                        // Ничего не делаем, оставляем заглушку
                        break
                    }
                }
            }
        }
    }
    
    /// Метод для обновления изображения в моделях
    func updateMovieImage(at index: Int, with image: UIImage) {
        guard var viewModel else { return }
        
        // Обновляем изображение в Box Office, если индекс в пределах массива
        if index < viewModel.boxOfficeMovies.count {
            viewModel.boxOfficeMovies[index].poster = image
        }
        
        if index < viewModel.sliderMovies.count {
            viewModel.sliderMovies[index].image = image
        }
        
        self.viewModel = viewModel
        // Отправляем обновленную модель на вью
        DispatchQueue.main.async {
            self.view?.configure(with: viewModel)
        }
    }
}
