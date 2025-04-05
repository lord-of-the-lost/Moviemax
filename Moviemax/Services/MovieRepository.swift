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
    
    // MARK: - Popular Movies
    func getPopularMovies() -> Result<[Movie], RepositoryError> {
        var result: Result<[Movie], RepositoryError> = .failure(.dataNotFound)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        networkService.fetchMovies { [weak self] networkResult in
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
                world: model.premiere?.world ?? ""
            ),
            genres: model.genres?.compactMap { Movie.Genre(name: $0.name ?? "") } ?? [],
            type: model.type ?? "",
            rating: Movie.Rating(
                value: model.rating?.kp ?? 0.0,
                votesCount: model.votes?.kp ?? 0
            ),
            description: model.description ?? "",
            shortDescription: model.shortDescription ?? "",
            name: model.name ?? "",
            enName: model.enName ?? "",
            persons: model.persons?.compactMap {
                Movie.Person(
                    id: $0.id ?? 0,
                    photo: $0.photo ?? "",
                    name: $0.name ?? "",
                    enName: $0.enName ?? "",
                    profession: $0.profession ?? "",
                    enProfession: $0.enProfession ?? ""
                )
            } ?? [],
            trailerURL: model.videos?.trailers?.first?.url ?? "",
            isFavorite: false,
            isRecent: false
        )
    }
}
