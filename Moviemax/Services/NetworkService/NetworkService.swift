//
//  NetworkService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, requestFailed, invalidData, invalidToken, decodeError
}

// MARK: - HTTPMethods
enum HTTPMethods: String {
    case GET, POST, PUT, DELETE
}

// MARK: - NetworkService
final class NetworkService {
    private let baseURL = "https://api.kinopoisk.dev/v1.4"
    private let apiKey = "KNWPBBJ-ZE1MWWK-P1P35CB-DSXZDQJ"
    //220FRRR-ZF0M9VE-JTNC41C-FSB7ATX
    //5QVH807-GAP49T6-QY0P863-EQW1F83
    //F6QX0P1-FQTMPFY-PWNT126-KXFHWZK
    //KNWPBBJ-ZE1MWWK-P1P35CB-DSXZDQJ
    private let imageCacheService: ImageCacheService
    
    init(imageCacheService: ImageCacheService) {
        self.imageCacheService = imageCacheService
    }
    
    /// Перечисление типов жанров для API
    enum GenreType: String {
        case all = "Все"
        case action = "боевик"
        case adventure = "приключения"
        case mystery = "детектив"
        case fantasy = "фэнтези"
        case others = "другие"
        case animation = "мультфильм"
        case biography = "биография"
        case drama = "драма"
        case history = "история"
        case music = "музыка"
        case romance = "мелодрама"
        case scienceFiction = "фантастика"
        case thriller = "триллер"
        case war = "военный"
        case western = "вестерн"
        
        /// Вернуть название жанра для API из TextConstants.Genres
        static func fromTextConstant(_ constant: String) -> GenreType {
            switch constant {
            case TextConstants.Genres.all.localized(): return .all
            case TextConstants.Genres.action.localized(): return .action
            case TextConstants.Genres.adventure.localized(): return .adventure
            case TextConstants.Genres.mystery.localized(): return .mystery
            case TextConstants.Genres.fantasy.localized(): return .fantasy
            case TextConstants.Genres.others.localized(): return .others
            case TextConstants.Genres.animation.localized(): return .animation
            case TextConstants.Genres.biography.localized(): return .biography
            case TextConstants.Genres.drama.localized(): return .drama
            case TextConstants.Genres.history.localized(): return .history
            case TextConstants.Genres.music.localized(): return .music
            case TextConstants.Genres.romance.localized(): return .romance
            case TextConstants.Genres.scienceFiction.localized(): return .scienceFiction
            case TextConstants.Genres.thriller.localized(): return .thriller
            case TextConstants.Genres.war.localized(): return .war
            case TextConstants.Genres.western.localized(): return .western
            default: return .all
            }
        }
    }
    
    /// Перечисление для рейтинга (5-балльная система)
    enum RatingType: Int {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        
        /// Получить диапазон для API (10-балльная система)
        var apiRange: String {
            switch self {
            case .five: return "9-10"
            case .four: return "7-8"
            case .three: return "5-6"
            case .two: return "3-4"
            case .one: return "1-2"
            }
        }
    }
    
    /// Получить список фильмов
    func fetchMovies(completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "/movie")
        
        // Добавляем параметры запроса
        let queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "notNullFields", value: "description"),
            URLQueryItem(name: "notNullFields", value: "movieLength"),
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let urlString = urlComponents?.url?.absoluteString else {
            completion(.failure(.badURL))
            return
        }
        
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Получить список фильмов с фильтрацией по жанру и рейтингу
    func fetchMovies(genre: GenreType? = nil, rating: RatingType? = nil, completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "/movie")
                
        // Базовые параметры запроса
        var queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "notNullFields", value: "description"),
            URLQueryItem(name: "notNullFields", value: "movieLength"),
            URLQueryItem(name: "type", value: "movie"),
        ]
        
        // Добавляем параметры жанра
        if let genre, genre != .all {
            queryItems.append(URLQueryItem(name: "genres.name", value: genre.rawValue))
        }
        
        // Добавляем параметры рейтинга
        if let rating = rating {
            queryItems.append(URLQueryItem(name: "rating.kp", value: rating.apiRange))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let urlString = urlComponents?.url?.absoluteString else {
            completion(.failure(.badURL))
            return
        }
        
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Получить список фильмов через поиск
    func fetchMovies(for query: String, completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        let urlString = baseURL + "/movie/search?query=\(query)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Получить информацию о людях по ID фильма
    func fetchCrew(
        byMovieID id: String,
        completion: @escaping (Result<PersonList, NetworkError>) -> Void
    ) {
        let urlString = "\(baseURL)/person?movies.id=\(id)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Загрузка картинки
    func loadImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        if let cachedData = imageCacheService.getImageFromCache(for: url) {
            DispatchQueue.main.async { completion(.success(cachedData)) }
            return
        }
        
        performDataRequest(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageCacheService.cacheImage(data, for: url)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private Methods
private extension NetworkService {
    func performDataRequest(
        urlString: String,
        method: HTTPMethods = .GET,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.requestFailed)) }
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode != 401 else {
                DispatchQueue.main.async { completion(.failure(.invalidToken)) }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async { completion(.failure(.invalidData)) }
                return
            }
            
            DispatchQueue.main.async { completion(.success(data)) }
        }.resume()
    }
    
    func performRequest<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        performDataRequest(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
