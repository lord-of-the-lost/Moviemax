//
//  NetworkService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, requestFailed, invalidData, decodeError
}

// MARK: - HTTPMethods
enum HTTPMethods: String {
    case GET, POST, PUT, DELETE
}

// MARK: - NetworkService
final class NetworkService {
    private let baseURL = "https://api.kinopoisk.dev/v1.4"
    private let apiKey = "5QVH807-GAP49T6-QY0P863-EQW1F83"
    private let imageCacheService: ImageCacheService
    
    init(imageCacheService: ImageCacheService) {
        self.imageCacheService = imageCacheService
    }
    
    /// Получить список фильмов
    func fetchMovies(completion: @escaping (Result<MovieList, NetworkError>) -> Void) {
        let urlString = baseURL + "/movie"
        
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
            if error != nil {
                DispatchQueue.main.async { completion(.failure(.requestFailed)) }
                return
            }
            
            guard let data = data else {
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
