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
        loadUserData()
        loadPopularMovies()
    }
    
    // MARK: - Private Methods
    
    private func loadUserData() {
        if let currentUser = userService.getCurrentUser() {
            let greeting = "Hi, \(currentUser.firstName)"
            let avatar = currentUser.avatar != nil ? UIImage(data: currentUser.avatar!) : UIImage(resource: .avatar)
            
            let userHeaderViewModel = UserHeaderView.UserHeaderViewModel(
                greeting: greeting,
                status: "only streaming movie lovers",
                avatar: avatar ?? UIImage(resource: .avatar)
            )
            
            updateViewModel(userHeader: userHeaderViewModel)
        }
    }
    
    private func loadPopularMovies() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result = movieRepository.getPopularMovies()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.processMovies(movies)
                case .failure(let error):
                    self.view?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func processMovies(_ movies: [Movie]) {
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
    
    private func updateViewModel(
        userHeader: UserHeaderView.UserHeaderViewModel? = nil,
        sliderMovies: [PosterCell.PosterCellViewModel]? = nil,
        boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel]? = nil,
        categories: [String]? = nil
    ) {
        // Получаем текущую модель или создаем новую
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
        // Отправляем обновленную модель на вью
        view?.configure(with: viewModel)
    }
    
    // Метод для извлечения уникальных категорий из фильмов
    private func extractUniqueCategories(from movies: [Movie]) -> [String] {
        let allGenres = movies.flatMap { $0.genres.map { $0.name } }
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return uniqueGenres
    }
    
    // Метод для преобразования Movie в PosterCell.PosterCellViewModel
    private func mapMovieToPosterCellViewModel(_ movie: Movie) -> PosterCell.PosterCellViewModel {
        return PosterCell.PosterCellViewModel(
            title: movie.name,
            category: movie.genres.first?.name ?? "Unknown",
            image: UIImage(resource: .posterPlaceholder)
        )
    }
    
    // Метод для преобразования Movie в MovieSmallCell.MovieSmallCellViewModel
    private func mapMovieToMovieSmallCellViewModel(_ movie: Movie) -> MovieSmallCell.MovieSmallCellViewModel {
        return MovieSmallCell.MovieSmallCellViewModel(
            title: movie.name,
            poster: UIImage(resource: .posterPlaceholder), // Заглушка, будет заменена после загрузки изображения
            filmLength: "\(movie.movieLength) Minutes",
            genre: movie.genres.first?.name ?? "Unknown",
            rating: String(format: "%.1f", movie.rating.value),
            voiceCount: "(\(movie.rating.votesCount))",
            isLiked: movie.isFavorite
        )
    }
    
    // Метод для загрузки изображений фильмов
    private func loadMovieImages(for movies: [Movie]) {
        for (index, movie) in movies.prefix(10).enumerated() {
            if !movie.poster.url.isEmpty {
                movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self.updateMovieImage(at: index, with: image)
                            }
                        }
                    case .failure:
                        // Ничего не делаем, оставляем заглушку
                        break
                    }
                }
            }
        }
    }
    
    // Метод для обновления изображения в моделях
    private func updateMovieImage(at index: Int, with image: UIImage) {
        guard var viewModel else { return }
        
        // Обновляем изображение в Box Office, если индекс в пределах массива
        if index < viewModel.boxOfficeMovies.count {
            viewModel.boxOfficeMovies[index].poster = image
        }
        self.viewModel = viewModel
        // Отправляем обновленную модель на вью
        view?.configure(with: viewModel)
    }
}

