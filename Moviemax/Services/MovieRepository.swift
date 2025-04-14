//
//  MovieRepository.swift
//  Moviemax
//
//  Created by Николай Игнатов on 05.04.2025.
//

import Foundation

enum RepositoryError: Error {
    case userNotAuthenticated
    case dataNotFound
    case networkError
    case saveError
}

// MARK: - MovieRepository
final class MovieRepository {
    private let coreDataManager: CoreDataManager
    private let networkService: NetworkService
    private let userService: UserService
    
    init(coreDataManager: CoreDataManager, networkService: NetworkService, userService: UserService) {
        self.coreDataManager = coreDataManager
        self.networkService = networkService
        self.userService = userService
    }
    
    // MARK: - Favorite Movies
    func getFavoriteMovies() -> Result<[Movie], RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        let favoriteMovies = coreDataManager.convertToMovies(Array(userEntity.favorites))
        return .success(favoriteMovies)
    }
    
    func toggleFavorite(movie: Movie) -> Result<Bool, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        // Проверяем, есть ли уже фильм в базе
        var movieEntity = coreDataManager.getMovie(by: movie.id)
        
        // Если фильма нет, создаем его
        if movieEntity == nil {
            movieEntity = coreDataManager.createMovie(from: movie)
        }
        
        guard let movieEntity = movieEntity else {
            return .failure(.saveError)
        }
        
        let isFavorite = userEntity.favorites.contains(movieEntity)
        
        if isFavorite {
            userEntity.favorites.remove(movieEntity)
        } else {
            userEntity.favorites.insert(movieEntity)
        }
        
        coreDataManager.saveContext()
        
        return .success(!isFavorite)
    }
    
    func isFavorite(movie: Movie) -> Result<Bool, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        guard let movieEntity = coreDataManager.getMovie(by: movie.id) else {
            return .success(false) // Если фильма нет в базе, он точно не в избранном
        }
        
        return .success(userEntity.favorites.contains(movieEntity))
    }
    
    func clearAllFavorites() -> Result<Void, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        userEntity.favorites.removeAll()
        coreDataManager.saveContext()
        
        return .success(())
    }
    
    // MARK: - Recently Watched Movies
    func getRecentlyWatchedMovies() -> Result<[Movie], RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        let recentMovies = coreDataManager.convertToMovies(Array(userEntity.recentWatch))
        return .success(recentMovies)
    }
    
    func addToRecentlyWatched(movie: Movie) -> Result<Void, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        // Проверяем, есть ли уже фильм в базе
        var movieEntity = coreDataManager.getMovie(by: movie.id)
        
        // Если фильма нет, создаем его
        if movieEntity == nil {
            movieEntity = coreDataManager.createMovie(from: movie)
        }
        
        guard let movieEntity = movieEntity else {
            return .failure(.saveError)
        }
        
        userEntity.recentWatch.insert(movieEntity)
        coreDataManager.saveContext()
        
        return .success(())
    }
    
    func removeFromRecentlyWatched(movie: Movie) -> Result<Void, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        guard let movieEntity = coreDataManager.getMovie(by: movie.id) else {
            return .success(()) // Если фильма нет в базе, ничего делать не нужно
        }
        
        userEntity.recentWatch.remove(movieEntity)
        coreDataManager.saveContext()
        
        return .success(())
    }
    
    func isRecentlyWatched(movie: Movie) -> Result<Bool, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        guard let movieEntity = coreDataManager.getMovie(by: movie.id) else {
            return .success(false) // Если фильма нет в базе, он точно не просмотрен недавно
        }
        
        return .success(userEntity.recentWatch.contains(movieEntity))
    }
    
    func clearAllRecentlyWatched() -> Result<Void, RepositoryError> {
        guard let currentUser = userService.getCurrentUser() else {
            return .failure(.userNotAuthenticated)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.dataNotFound)
        }
        
        userEntity.recentWatch.removeAll()
        coreDataManager.saveContext()
        
        return .success(())
    }
    
    // MARK: - Movie Search
    func searchMovies(query: String) -> Result<[Movie], RepositoryError> {
        var result: Result<[Movie], RepositoryError> = .failure(.dataNotFound)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        networkService.fetchMovies(for: query) { [weak self] networkResult in
            guard let self = self else {
                semaphore.signal()
                return
            }
            
            switch networkResult {
            case .success(let movieList):
                if let docs = movieList.docs, !docs.isEmpty {
                    let movies = docs.compactMap { self.mapMovieModelToMovie($0) }
                    
                    // Сохраняем результаты в базу данных
                    let movieEntities = movies.map { self.coreDataManager.createMovie(from: $0) }
                    result = .success(self.coreDataManager.convertToMovies(movieEntities))
                } else {
                    result = .success([]) // Пустой результат поиска
                }
                
            case .failure:
                result = .failure(.networkError)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    // MARK: - Filtered Movies
    func getMovies(genre: String? = nil, rating: Int? = nil) -> Result<[Movie], RepositoryError> {
        var result: Result<[Movie], RepositoryError> = .failure(.dataNotFound)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        // Преобразование параметров в новые типы
        let genreType = genre.flatMap { NetworkService.GenreType.fromTextConstant($0) }
        let ratingType = rating.flatMap { NetworkService.RatingType(rawValue: $0) }
        
        networkService.fetchMovies(genre: genreType, rating: ratingType) { [weak self] networkResult in
            guard let self else {
                semaphore.signal()
                return
            }
            
            switch networkResult {
            case .success(let movieList):
                if let docs = movieList.docs, !docs.isEmpty {
                    let movies = docs.compactMap { self.mapMovieModelToMovie($0) }
                    
                    // Сохраняем результаты в базу данных
                    let movieEntities = movies.map { self.coreDataManager.createMovie(from: $0) }
                    result = .success(self.coreDataManager.convertToMovies(movieEntities))
                } else {
                    result = .success([]) // Пустой результат
                }
                
            case .failure:
                result = .failure(.networkError)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    // MARK: - Popular Movies
    func getPopularMovies() -> Result<[Movie], RepositoryError> {
        var result: Result<[Movie], RepositoryError> = .failure(.dataNotFound)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        networkService.fetchMovies { [weak self] networkResult in
            guard let self else {
                semaphore.signal()
                return
            }
            
            switch networkResult {
            case .success(let movieList):
                if let docs = movieList.docs, !docs.isEmpty {
                    let movies = docs.compactMap { self.mapMovieModelToMovie($0) }
                    
                    // Сохраняем результаты в базу данных
                    let movieEntities = movies.map { self.coreDataManager.createMovie(from: $0) }
                    result = .success(self.coreDataManager.convertToMovies(movieEntities))
                } else {
                    result = .success([]) // Пустой результат
                }
                
            case .failure:
                result = .failure(.networkError)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    // MARK: - Image Loading
    func loadImage(from urlString: String, completion: @escaping (Result<Data, RepositoryError>) -> Void) {
        networkService.loadImage(from: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    // MARK: - Helpers
    private func mapMovieModelToMovie(_ model: MovieModel) -> Movie {
        return Movie(
            id: model.id ?? 0,
            poster: Movie.Poster(
                url: model.poster?.url ?? "",
                previewUrl: model.poster?.previewUrl ?? ""
            ),
            movieLength: model.movieLength ?? 0,
            premiere: Movie.Premiere(
                world: model.premiere?.world ?? "01.04.2000"
            ),
            genres: model.genres?.compactMap { Movie.Genre(name: $0.name ?? "") } ?? [],
            type: model.type ?? "",
            rating: Movie.Rating(
                value: (model.rating?.kp ?? 0) > 0 ? model.rating?.kp ?? Double.random(in: 1...5) : Double.random(in: 1...5),
                votesCount: (model.votes?.kp ?? 0) > 0 ? model.votes?.kp ?? Int.random(in: 20...999) : Int.random(in: 20...999)
            ) ,
            description: model.description ?? "",
            shortDescription: model.shortDescription ?? "",
            name: model.name ?? "",
            enName: model.enName ?? "",
            persons: {
                let mappedPersons = model.persons?.compactMap {
                    Movie.Person(
                        id: $0.id ?? 0,
                        photo: $0.photo ?? "",
                        name: $0.name ?? "",
                        enName: $0.enName ?? "",
                        profession: $0.profession ?? "",
                        enProfession: $0.enProfession ?? ""
                    )
                } ?? []
                return mappedPersons.isEmpty ? mockPersons : mappedPersons
            }(),
            trailerURL: model.videos?.trailers?.first?.url ?? "https://yandex.ru/video/preview/10510689359700548639",
            isFavorite: false,
            isRecent: false
        )
    }
    
    private let mockPersons: [Movie.Person] = [
        .init(
            id: 1,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/e32de330-17e9-4c83-8a05-a2c2c1f96dd2/280x420",
            name: "Леонардо ДиКаприо",
            enName: "Leonardo DiCaprio",
            profession: "Актер",
            enProfession: "Actor"
        ),
        .init(
            id: 2,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/637271d5-61b4-4e46-ac83-6d07494c7645/280x420",
            name: "Кристофер Нолан",
            enName: "Christopher Nolan",
            profession: "Режиссер",
            enProfession: "Director"
        ),
        .init(
            id: 3,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/0c15d161-eb02-4125-8b84-49ac2f58f9c0/280x420",
            name: "Марго Робби",
            enName: "Margot Robbie",
            profession: "Актриса",
            enProfession: "Actor"
        ),
        .init(
            id: 4,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/a8f3599c-78d5-4f34-9ca1-5de86dd4aa58/280x420",
            name: "Квентин Тарантино",
            enName: "Quentin Tarantino",
            profession: "Режиссер",
            enProfession: "Director"
        ),
        .init(
            id: 5,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/0f9f9490-6ce0-4612-9247-9ecee137f860/280x420",
            name: "Скарлетт Йоханссон",
            enName: "Scarlett Johansson",
            profession: "Актриса",
            enProfession: "Actor"
        ),
        .init(
            id: 6,
            photo: "https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/4e0f0816-8d7b-4108-9244-f1f08e48a6cf/280x420",
            name: "Мартин Скорсезе",
            enName: "Martin Scorsese",
            profession: "Режиссер",
            enProfession: "Director"
        )]
}
