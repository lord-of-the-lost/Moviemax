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
    
    // Кеш всех загруженных фильмов
    private var allMovies: [Movie] = []
    
    // Фильтрованные фильмы для boxOffice
    private var filteredMovies: [Movie] = []
    
    private var viewModel: HomeViewModel?
    private let router: HomeRouter
    private let movieRepository: MovieRepository
    private let userService: UserService
    
    // Текущий выбранный жанр для фильтрации
    private var selectedGenre: String?
  
    // Свойства для кеширования изображений
    private var movieImagesCache: [String: UIImage] = [:]
    
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
        
        // Обновляем статус избранного только если у нас уже загружены фильмы
        if !allMovies.isEmpty {
            checkFavoriteStatus(for: allMovies)
        }
    }
    
    // Метод для обработки нажатия на кнопку лайка в boxOffice секции
    func likeButtonTapped(at index: Int) {
        guard let movie = filteredMovies[safe: index] else { return }
        
        // Переключаем статус избранного для фильма
        let result = movieRepository.toggleFavorite(movie: movie)
        
        switch result {
        case .success(let isFavorite):
            // Обновляем статус в фильтрованных фильмах
            filteredMovies[index].isFavorite = isFavorite
            
            // Обновляем статус в кеше всех фильмов
            if let originalIndex = allMovies.firstIndex(where: { $0.id == movie.id }) {
                allMovies[originalIndex].isFavorite = isFavorite
            }
            
            // Обновляем только конкретную ячейку в boxOffice
            updateBoxOfficeItemAt(index: index)
            
        case .failure(let error):
            view?.showAlert(
                title: "Ошибка",
                message: "Не удалось обновить статус избранного: \(error.localizedDescription)"
            )
        }
    }
    
    // Метод для обработки тапа по фильму в слайдере
    func didTapSliderMovie(at index: Int) {
        guard let movie = allMovies[safe: index] else { return }
        router.showMovieDetails(movie: movie)
    }
    
    // Метод для обработки тапа по фильму в boxOffice
    func didTapBoxOfficeMovie(at index: Int) {
        guard let movie = filteredMovies[safe: index] else { return }
        router.showMovieDetails(movie: movie)
    }
    
    // Метод для перехода на экран со всеми фильмами
    func showAllMovies() {
        router.showAllMovies()
    }
    
    // Метод для обработки выбора жанра
    func didSelectGenre(at index: Int, value: String) {
        didSelectGenre(value)
    }
    
    func didSelectGenre(_ value: String) {
        selectedGenre = value
        
        if value == TextConstants.Genres.all.localized() {
            // Если выбрана категория "Все", отображаем все фильмы
            filteredMovies = allMovies
        } else {
            // Фильтруем фильмы только по первому жанру
            filteredMovies = allMovies.filter { movie in
                guard let firstGenre = movie.genres.first else { return false }
                return firstGenre.name.lowercased() == value.lowercased()
            }
        }
        
        if filteredMovies.isEmpty {
            view?.showAlert(
                title: "Информация",
                message: "По выбранному жанру фильмы не найдены"
            )
            
            // Возвращаемся к показу всех фильмов
            selectedGenre = TextConstants.Genres.all.localized()
            filteredMovies = allMovies
        }
        
        // Обновляем только boxOffice секцию с отфильтрованными фильмами
        updateBoxOfficeModels()
    }
}

// MARK: - Private Methods
private extension HomePresenter {
    // Загрузка данных пользователя
    func loadUserData() {
        guard let currentUser = userService.getCurrentUser() else { return }
        
        let avatar = currentUser.avatar.flatMap { UIImage(data: $0) } ?? UIImage(resource: .avatar)
        let viewModel = UserHeaderView.UserHeaderViewModel(
            greeting: "\(TextConstants.Home.shortGreeting.localized()), \(currentUser.firstName)",
            status: TextConstants.Home.status.localized(),
            avatar: avatar
        )
        
        // Обновляем только заголовок с данными пользователя
        updateUserHeader(userHeader: viewModel)
    }
    
    // Загрузка популярных фильмов
    func loadPopularMovies() {
        // Показываем индикатор загрузки
        view?.showLoadingIndicator()
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result = movieRepository.getPopularMovies()
            
            DispatchQueue.main.async {
                self.view?.hideLoadingIndicator()
                
                switch result {
                case .success(let movies):
                    if movies.isEmpty {
                        self.view?.showAlert(
                            title: "Информация",
                            message: "Не найдено ни одного фильма"
                        )
                        return
                    }
                    
                    // Сохраняем все загруженные фильмы в кеш
                    self.allMovies = movies
                    self.filteredMovies = movies // Изначально отображаем все фильмы
                    
                    // Инициализируем модель представления всех данных
                    self.initializeViewModel(with: movies)
                    
                    // Загружаем изображения для фильмов
                    self.loadImagesForMovies(movies)
                    
                    // Проверяем статус избранного для фильмов
                    self.checkFavoriteStatus(for: movies)
                    
                case .failure(let error):
                    self.view?.showAlert(
                        title: "Ошибка",
                        message: "Не удалось загрузить фильмы: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
    
    // Загрузка изображений для фильмов
    func loadImagesForMovies(_ movies: [Movie]) {
        for (index, movie) in movies.enumerated() {
            if !movie.poster.url.isEmpty {
                // Если изображение уже в кеше, используем его
                if let cachedImage = movieImagesCache[movie.poster.url] {
                    // Обновляем модель сразу с кешированным изображением
                    updateMovieModelsWithImage(index: index, image: cachedImage, movieId: movie.id.description)
                } else {
                    // Загружаем изображение, если его нет в кеше
                    movieRepository.loadImage(from: movie.poster.url) { [weak self] result in
                        guard let self else { return }
                        
                        switch result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                // Сохраняем изображение в кеш
                                self.movieImagesCache[movie.poster.url] = image
                                
                                // Обновляем модели с загруженным изображением
                                self.updateMovieModelsWithImage(index: index, image: image, movieId: movie.id.description)
                            }
                        case .failure:
                            // Ничего не делаем, оставляем заглушку
                            break
                        }
                    }
                }
            }
        }
    }
    
    // Обновление моделей с загруженным изображением
    func updateMovieModelsWithImage(index: Int, image: UIImage, movieId: String) {
        DispatchQueue.main.async {
            // Обновляем вью модели вместо прямого обновления ячеек
            self.updateViewModelsWithImage(index: index, image: image, movieId: movieId)
        }
    }
    
    // Обновление вью моделей с новым изображением
    func updateViewModelsWithImage(index: Int, image: UIImage, movieId: String) {
        guard var viewModel = self.viewModel else { return }
        
        // Обновляем изображение в слайдере
        if index < allMovies.count && index < viewModel.sliderMovies.count {
            viewModel.sliderMovies[index].image = image
        }
        
        // Обновляем изображение в boxOffice
        for (boxIndex, movie) in filteredMovies.enumerated() where movie.id.description == movieId {
            if boxIndex < viewModel.boxOfficeMovies.count {
                viewModel.boxOfficeMovies[boxIndex].poster = image
            }
        }
        
        // Сохраняем обновленную модель
        self.viewModel = viewModel
        
        // Обновляем UI через обновление моделей
        view?.configure(with: viewModel)
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
            
            // Обновляем кеш всех фильмов с учетом статуса избранного
            self.allMovies = updatedMovies
            
            // Обновляем фильтрованные фильмы в соответствии с выбранным жанром
            if let selectedGenre = self.selectedGenre, selectedGenre != TextConstants.Genres.all.localized() {
                self.filteredMovies = updatedMovies.filter { movie in
                    guard let firstGenre = movie.genres.first else { return false }
                    return firstGenre.name.lowercased() == selectedGenre.lowercased()
                }
            } else {
                self.filteredMovies = updatedMovies
            }
            
            // Обновляем модели ячеек в UI
            self.updateSliderModels()
            self.updateBoxOfficeModels()
        }
    }
    
    // Инициализация модели представления
    func initializeViewModel(with movies: [Movie]) {
        // Формируем модели для слайдера
        let sliderModels = movies.map { mapMovieToPosterCellViewModel($0) }
        
        // Формируем модели для boxOffice
        let boxOfficeModels = movies.map { mapMovieToMovieSmallCellViewModel($0) }
        
        // Формируем категории фильмов на основе жанров
        let categories = [TextConstants.Genres.all.localized()] + extractUniqueCategories(from: movies)
        
        // Создаем полную модель для отображения
        let newViewModel = HomeViewModel(
            userHeader: UserHeaderView.UserHeaderViewModel(
                greeting: TextConstants.Home.greeting.localized(),
                status: TextConstants.Home.status.localized(),
                avatar: UIImage(resource: .avatar)
            ),
            sliderMovies: sliderModels,
            categories: categories,
            boxOfficeMovies: boxOfficeModels
        )
        
        // Сохраняем модель и отправляем на контроллер
        viewModel = newViewModel
        view?.configure(with: newViewModel)
    }
    
    // Обновление заголовка с данными пользователя
    func updateUserHeader(userHeader: UserHeaderView.UserHeaderViewModel) {
        guard var currentViewModel = viewModel else { return }
        
        currentViewModel.userHeader = userHeader
        viewModel = currentViewModel
        
        // Обновляем только заголовок
        view?.updateUserHeader(with: userHeader)
    }
    
    // Обновление моделей для слайдера
    func updateSliderModels() {
        guard var currentViewModel = viewModel else { return }
        
        // Обновляем модели для слайдера
        let sliderModels = allMovies.map { mapMovieToPosterCellViewModel($0) }
        currentViewModel.sliderMovies = sliderModels
        viewModel = currentViewModel
        
        // Обновляем только слайдер
        view?.updateSliderSection(with: sliderModels)
    }
    
    // Обновление моделей для boxOffice
    func updateBoxOfficeModels() {
        guard var currentViewModel = viewModel else { return }
        
        // Обновляем модели для boxOffice
        let boxOfficeModels = filteredMovies.map { mapMovieToMovieSmallCellViewModel($0) }
        currentViewModel.boxOfficeMovies = boxOfficeModels
        viewModel = currentViewModel
        
        // Обновляем только boxOffice секцию
        view?.updateBoxOfficeSection(with: boxOfficeModels)
    }
    
    // Обновление конкретного элемента в boxOffice
    func updateBoxOfficeItemAt(index: Int) {
        guard 
            var currentViewModel = viewModel,
            index < filteredMovies.count 
        else { return }
        
        // Обновляем конкретную модель
        let updatedModel = mapMovieToMovieSmallCellViewModel(filteredMovies[index])
        currentViewModel.boxOfficeMovies[index] = updatedModel
        viewModel = currentViewModel
        
        // Обновляем только конкретную ячейку
        view?.updateBoxOfficeItem(at: index, with: updatedModel)
    }
    
    // Метод для извлечения уникальных категорий из фильмов
    func extractUniqueCategories(from movies: [Movie]) -> [String] {
        // Получаем все жанры из всех фильмов
        let allGenres = movies.flatMap { movie -> [String] in
            // Берем первую категорию из каждого фильма
            movie.genres.prefix(1).map { genre -> String in
                // Преобразуем первую букву в верхний регистр
                if let firstChar = genre.name.first {
                    let capitalizedGenre = String(firstChar).uppercased() + String(genre.name.dropFirst())
                    return capitalizedGenre
                }
                return genre.name
            }
        }
        
        // Получаем уникальные жанры
        let uniqueGenres = Array(Set(allGenres)).sorted()
        return uniqueGenres
    }
    
    // Преобразование Movie в PosterCell.PosterCellViewModel
    func mapMovieToPosterCellViewModel(_ movie: Movie) -> PosterCell.PosterCellViewModel {
        // Получаем первую категорию и преобразуем первую букву в верхний регистр
        let category: String
        if let genreName = movie.genres.first?.name, !genreName.isEmpty {
            if let firstChar = genreName.first {
                category = String(firstChar).uppercased() + String(genreName.dropFirst())
            } else {
                category = "Unknown"
            }
        } else {
            category = "Unknown"
        }
        
        // Используем кешированное изображение, если оно есть
        let image: UIImage
        if !movie.poster.url.isEmpty, let cachedImage = movieImagesCache[movie.poster.url] {
            image = cachedImage
        } else {
            image = UIImage(resource: .posterPlaceholder)
        }
        
        return PosterCell.PosterCellViewModel(
            title: movie.name,
            category: category,
            image: image
        )
    }
    
    // Преобразование Movie в MovieSmallCell.MovieSmallCellViewModel
    func mapMovieToMovieSmallCellViewModel(_ movie: Movie) -> MovieSmallCell.MovieSmallCellViewModel {
        // Всегда используем первый жанр фильма
        let genre: String
        if let firstGenre = movie.genres.first?.name, !firstGenre.isEmpty {
            if let firstChar = firstGenre.first {
                genre = String(firstChar).uppercased() + String(firstGenre.dropFirst())
            } else {
                genre = firstGenre
            }
        } else {
            genre = "Unknown"
        }
        
        // Используем кешированное изображение, если оно есть
        let poster: UIImage
        if !movie.poster.url.isEmpty, let cachedImage = movieImagesCache[movie.poster.url] {
            poster = cachedImage
        } else {
            poster = UIImage(resource: .posterPlaceholder)
        }
        
        return MovieSmallCell.MovieSmallCellViewModel(
            title: movie.name,
            poster: poster,
            filmLength: "\(movie.movieLength) Minutes",
            genre: genre,
            rating: String(format: "%.1f", movie.rating.value),
            voiceCount: "(\(movie.rating.votesCount))",
            isLiked: movie.isFavorite
        )
    }
}
