//
//  SearchPresenter.swift
//  Moviemax
//
//  Created by Penkov Alexander on 10.04.2025.
//

import UIKit

protocol SearchPresenterProtocol {
    var state: SearchState { get }
    
    func setupView(_ view: SearchViewControllerProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(at index: Int)
    func likeButtonTapped(at index: Int)
    func filterButtonTapped()
    func searchTextChanged(_ text: String)
}

final class SearchPresenter {
    private weak var view: SearchViewControllerProtocol?
    private let router: SearchRouter
    private let movieRepository: MovieRepository
    private let userService: UserService
    
    // Кеш всех найденных фильмов
    private var searchResults: [Movie] = []
    
    // Фильтрованные фильмы для отображения
    private var filteredMovies: [Movie] = []
    
    // Текущий поисковый запрос
    private var currentQuery: String = ""
    
    // Таймер для задержки поиска при вводе текста
    private var searchTimer: Timer?
    
    // Свойства для кеширования изображений
    private var movieImagesCache: [String: UIImage] = [:]
    
    var state: SearchState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    init(router: SearchRouter, dependency: DI) {
        self.router = router
        self.movieRepository = dependency.movieRepository
        self.userService = dependency.userService
    }
}

// MARK: - SearchPresenterProtocol
extension SearchPresenter: SearchPresenterProtocol {
    func setupView(_ view: SearchViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        state = .empty
    }
    
    func viewWillAppear() {
        // Если у нас есть результаты поиска, обновляем статус избранного
        if !searchResults.isEmpty {
            checkFavoriteStatus(for: searchResults)
        }
    }
    
    func didSelectMovie(at index: Int) {
        guard let movie = filteredMovies[safe: index] else { return }
        router.showMovieDetails(movie: movie)
    }
    
    func likeButtonTapped(at index: Int) {
        guard let movie = filteredMovies[safe: index] else { return }
        
        // Переключаем статус избранного для фильма
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            // Обновляем статус в фильтрованных фильмах
            filteredMovies[index].isFavorite = isFavorite
            
            // Обновляем статус в кеше всех фильмов
            if let originalIndex = searchResults.firstIndex(where: { $0.id == movie.id }) {
                searchResults[originalIndex].isFavorite = isFavorite
            }
            
            // Обновляем только конкретную ячейку
            updateMovieAt(index: index)
            
        case .failure(let error):
            view?.showAlert(
                title: TextConstants.Auth.Errors.errorTitle.localized(),
                message: TextConstants.Favorites.Errors.couldntUpdateFavoritesStatus.localized() + error.localizedDescription
            )
        }
    }
    
    func filterButtonTapped() {
        router.navigateToFilter()
    }
    
    // Обработка ввода текста в поисковое поле
    func searchTextChanged(_ text: String) {
        currentQuery = text
        
        // Отменяем предыдущий таймер, если он был
        searchTimer?.invalidate()
        
        if text.isEmpty {
            // Если текст пустой, очищаем результаты
            searchResults = []
            filteredMovies = []
            state = .empty
            return
        }
        
        // Устанавливаем новый таймер с задержкой
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.performSearch(query: text)
        }
    }
}

// MARK: - Private Methods
private extension SearchPresenter {
    func performSearch(query: String) {
        // Показываем индикатор загрузки
        view?.showLoadingIndicator()
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result = self.movieRepository.searchMovies(query: query)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.processSearchResults(movies: movies, query: query)
                case .failure(let error):
                    self.view?.hideLoadingIndicator()
                    self.view?.showAlert(
                        title:  TextConstants.Auth.Errors.errorTitle.localized(),
                        message: "Не удалось выполнить поиск: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
    // Обработка результатов поиска
    func processSearchResults(movies: [Movie], query: String) {
        if movies.isEmpty {
            self.view?.hideLoadingIndicator()
            self.searchResults = []
            self.filteredMovies = []
            self.state = .empty
            return
        }
        
        // Фильтруем фильмы, чтобы убедиться, что у них есть все необходимые данные
        let validMovies = movies.filter { movie in
            !movie.name.isEmpty && movie.movieLength > 0 && !movie.genres.isEmpty
        }
                            
        if validMovies.isEmpty {
            self.view?.hideLoadingIndicator()
            self.view?.showAlert(
                title: TextConstants.Search.screenTitle.localized(),
                message: "По запросу '\(query)' не найдено подходящих фильмов"
            )
            self.state = .empty
            return
        }
        
        // Сохраняем отфильтрованные фильмы
        self.searchResults = validMovies
        self.filteredMovies = validMovies
        
        // Загружаем изображения для фильмов
        self.loadImagesForMovies(validMovies)
    }
    
    // Загрузка изображений для фильмов
    func loadImagesForMovies(_ movies: [Movie]) {
        let group = DispatchGroup()
        
        // Создаем новый массив фильмов для обновления
        var updatedMovies = movies
        
        for (index, movie) in movies.enumerated() {
            if !movie.poster.url.isEmpty {
                // Если изображение уже в кеше, используем его
                if movieImagesCache[movie.poster.url] != nil {
                    // Изображение уже в кеше
                } else {
                    // Загружаем изображение, если его нет в кеше
                    group.enter()
                    
                    movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                        guard let self else {
                            group.leave()
                            return
                        }
                        
                        switch result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                // Сохраняем изображение в кеш
                                self.movieImagesCache[movie.poster.url] = image
                            }
                        case .failure:
                            break
                        }
                        group.leave()
                    }
                }
            } else {
                // Обновляем фильм в массиве даже если нет изображения
                updatedMovies[index] = movie
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            // Обновляем только когда все изображения загружены
            self.searchResults = updatedMovies
            self.filteredMovies = updatedMovies
            self.updateMovieModels()
            
            // Обновляем статус избранного
            self.checkFavoriteStatus(for: updatedMovies)
        }
    }
    
    // Проверка статуса избранного для списка фильмов
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
            
            // Обновляем кеш всех найденных фильмов с учетом статуса избранного
            self.searchResults = updatedMovies
            self.filteredMovies = updatedMovies
            
            // Скрываем индикатор загрузки и обновляем UI
            self.view?.hideLoadingIndicator()
            self.updateMovieModels()
        }
    }
    
    // Обновление всех моделей фильмов
    func updateMovieModels() {
        // Преобразуем модели и обновляем состояние
        let movieModels = filteredMovies.map { mapMovieToMovieLargeCellViewModel($0) }
        if movieModels.isEmpty {
            state = .empty
        } else {
            state = .content(movieModels)
        }
    }
    
    // Обновление конкретной модели фильма
    func updateMovieAt(index: Int) {
        guard 
            index < filteredMovies.count,
            case .content(var models) = state,
            index < models.count
        else { return }
        
        // Обновляем конкретную модель
        models[index] = mapMovieToMovieLargeCellViewModel(filteredMovies[index])
        state = .content(models)
    }
    
    // Преобразование Movie в MovieLargeCell.MovieLargeCellViewModel
    func mapMovieToMovieLargeCellViewModel(_ movie: Movie) -> MovieLargeCell.MovieLargeCellViewModel {
        // Обработка жанра
        let genre: String
        if let firstGenre = movie.genres.first?.name, !firstGenre.isEmpty {
            if let firstChar = firstGenre.first {
                genre = String(firstChar).uppercased() + String(firstGenre.dropFirst())
            } else {
                genre = firstGenre
            }
        } else {
            genre = "Неизвестно"
        }
        
        // Формируем длительность фильма
        let filmLength: String
        if movie.movieLength > 0 {
            filmLength = "\(movie.movieLength) \(TextConstants.Favorites.minutes.localized())"
        } else {
            filmLength = "Неизвестно"
        }
        
        // Используем кешированное изображение, если оно есть
        let poster: UIImage
        if !movie.poster.url.isEmpty, let cachedImage = movieImagesCache[movie.poster.url] {
            poster = cachedImage
        } else {
            poster = UIImage(resource: .posterPlaceholder)
        }
        
        // Формируем заголовок (название фильма)
        let title = !movie.name.isEmpty ? movie.name : "Без названия"
        
        return MovieLargeCell.MovieLargeCellViewModel(
            title: title,
            poster: poster,
            filmLength: filmLength,
            reliseDate: movie.premiere.world,
            genre: genre,
            isLiked: movie.isFavorite
        )
    }
}
