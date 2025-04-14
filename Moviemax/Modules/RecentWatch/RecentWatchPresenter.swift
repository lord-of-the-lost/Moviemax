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
    
    // Кеш всех загруженных фильмов
    private var allRecentMovies: [Movie] = []
    
    // Фильтрованные фильмы для отображения
    private var recentMovies: [Movie] = []
    
    // Кеш загруженных изображений
    private var movieImagesCache: [String: UIImage] = [:]
    
    // Текущий выбранный жанр для фильтрации
    private var selectedGenre: String?
    
    var state: RecentWatchState = .empty {
        didSet {
            view?.show(state)
        }
    }
    
    // Динамический список жанров, который будет заполняться из фильмов
    private(set) var genres: [String] = []
    
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
            
            // Обновляем статус в кеше всех фильмов
            if let originalIndex = allRecentMovies.firstIndex(where: { $0.id == movie.id }) {
                allRecentMovies[originalIndex].isFavorite = isFavorite
            }
            
            // Обновляем UI конкретной ячейки
            updateMovieViewModel(at: index)
            
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
    
    // Метод для обработки выбора жанра по индексу
    func didSelectGenre(at index: Int, value: String) {
        didSelectGenre(value)
    }
    
    // Метод для обработки выбора жанра по значению
    func didSelectGenre(_ value: String) {
        selectedGenre = value
        
        if value == TextConstants.Genres.all.localized() {
            // Если выбрана категория "Все", отображаем все фильмы
            recentMovies = allRecentMovies
        } else {
            // Фильтруем фильмы только по первому жанру
            recentMovies = allRecentMovies.filter { movie in
                guard let firstGenre = movie.genres.first else { return false }
                return firstGenre.name.lowercased() == value.lowercased()
            }
        }
        
        if recentMovies.isEmpty {
            view?.showAlert(
                title: "Информация",
                message: "По выбранному жанру фильмы не найдены"
            )
            
            // Возвращаемся к показу всех фильмов
            selectedGenre = TextConstants.Genres.all.localized()
            recentMovies = allRecentMovies
        }
        
        // Обновляем только UI с отфильтрованными фильмами
        updateMovieViewModels()
    }
    
    // Возвращает текущий выбранный жанр
    func getSelectedGenre() -> String {
        return selectedGenre ?? TextConstants.Genres.all.localized()
    }
}

// MARK: - Private Methods
private extension RecentWatchPresenter {
    func loadRecentWatchMovies() {
        let result = movieRepository.getRecentlyWatchedMovies()
        
        switch result {
        case .success(let movies):
            self.allRecentMovies = movies
            
            // Обновляем список жанров на основе полученных фильмов
            updateGenres(from: movies)
            
            // Применяем фильтр по жанру, если он был выбран ранее
            if let selectedGenre = self.selectedGenre, selectedGenre != TextConstants.Genres.all.localized() {
                recentMovies = movies.filter { movie in
                    guard let firstGenre = movie.genres.first else { return false }
                    return firstGenre.name.lowercased() == selectedGenre.lowercased()
                }
                
                // Если после фильтрации нет фильмов, показываем все
                if recentMovies.isEmpty {
                    self.selectedGenre = TextConstants.Genres.all.localized()
                    recentMovies = movies
                }
            } else {
                recentMovies = movies
            }
            
            if movies.isEmpty {
                state = .empty
            } else {
                updateMovieViewModels()
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
    
    /// Обновляет список жанров на основе загруженных фильмов
    func updateGenres(from movies: [Movie]) {
        // Получаем первый жанр из каждого фильма
        let uniqueGenres = extractUniqueCategories(from: movies)
        
        // Формируем окончательный список с категорией "Все" в начале
        let allGenres = [TextConstants.Genres.all.localized()] + uniqueGenres
        
        // Если список жанров изменился - обновляем UI
        if genres != allGenres {
            // Проверяем, существует ли выбранный жанр в новом списке
            let needResetToAll = selectedGenre != nil && 
                                selectedGenre != TextConstants.Genres.all.localized() && 
                                !allGenres.contains(selectedGenre!)
            
            // Обновляем список жанров
            genres = allGenres
            view?.updateGenres(genres)
            
            // Если выбранный жанр больше не существует, сбрасываем на "All"
            if needResetToAll {
                selectedGenre = TextConstants.Genres.all.localized()
                recentMovies = allRecentMovies
                updateMovieViewModels()
                
                // Уведомляем пользователя, что фильтр был сброшен
                view?.showAlert(
                    title: "Информация",
                    message: "Выбранная категория больше не доступна. Показаны все фильмы."
                )
            }
        }
    }
    
    /// Извлекает уникальные категории из списка фильмов (берет только первый жанр из каждого фильма)
    func extractUniqueCategories(from movies: [Movie]) -> [String] {
        // Получаем все первые жанры из всех фильмов
        let allGenres = movies.compactMap { movie -> String? in
            guard let firstGenre = movie.genres.first?.name else { return nil }
            return firstGenre
        }
        
        // Получаем уникальные жанры и сортируем
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return uniqueGenres
    }
    
    /// Обновляет все вьюмодели фильмов в UI
    func updateMovieViewModels() {
        let viewModels = recentMovies.map { mapMovieToViewModel($0) }
        state = .content(viewModels)
    }
    
    /// Обновляет вьюмодель фильма по индексу
    func updateMovieViewModel(at index: Int) {
        if case .content(var viewModels) = state, index < recentMovies.count, index < viewModels.count {
            viewModels[index] = mapMovieToViewModel(recentMovies[index])
            state = .content(viewModels)
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
        
        // Используем кешированное изображение если доступно
        let poster: UIImage
        if !movie.poster.url.isEmpty, let cachedImage = movieImagesCache[movie.poster.url] {
            poster = cachedImage
        } else {
            poster = UIImage(resource: .posterPlaceholder)
        }
        
        return MovieLargeCell.MovieLargeCellViewModel(
            title: movie.name,
            poster: poster,
            filmLength: "\(movie.movieLength) \(TextConstants.Favorites.minutes.localized())",
            reliseDate: movie.premiere.world,
            genre: movie.genres.first?.name ?? "Unknown",
            isLiked: isLiked
        )
    }
    
    /// Загружает изображения для фильмов и обновляет UI
    private func loadImagesForMovies(_ movies: [Movie]) {
        for (_, movie) in movies.enumerated() {
            guard !movie.poster.url.isEmpty else { continue }
            
            // Если изображение уже в кеше, используем его сразу
            if let cachedImage = movieImagesCache[movie.poster.url] {
                updateMovieImage(for: movie, with: cachedImage)
                continue
            }
            
            // Загружаем изображение если его нет в кеше
            movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            // Сохраняем в кеш
                            self.movieImagesCache[movie.poster.url] = image
                            // Обновляем изображение во всех фильмах с таким же URL
                            self.updateMovieImage(for: movie, with: image)
                        }
                    case .failure:
                        // В случае ошибки оставляем изображение-заглушку
                        break
                    }
                }
            }
        }
    }
    
    /// Обновляет изображение для всех фильмов с заданным ID
    func updateMovieImage(for movie: Movie, with image: UIImage) {
        // Обновляем изображения во всех фильтрованных фильмах с тем же URL
        guard case .content(var viewModels) = state else { return }
        
        var updated = false
        
        // Ищем все фильмы с таким же ID в фильтрованном списке
        for (index, filteredMovie) in recentMovies.enumerated() where filteredMovie.id == movie.id {
            if index < viewModels.count {
                viewModels[index].poster = image
                updated = true
            }
        }
        
        // Обновляем состояние только если были изменения
        if updated {
            state = .content(viewModels)
        }
    }
    
    /// Обновляет изображение в модели и UI по индексу
    func updateMovieImage(at index: Int, with image: UIImage) {
        guard case .content(var viewModels) = state, index < viewModels.count else {
            return
        }
        
        viewModels[index].poster = image
        
        state = .content(viewModels)
    }
}
