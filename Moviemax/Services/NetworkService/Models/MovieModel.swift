//
//  MovieModel.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import Foundation

// MARK: - MovieModel
struct MovieList: Decodable {
    let docs: [MovieModel]?
}

// MARK: - MovieModel
struct MovieModel: Decodable {
    let id: Int?
    let poster: Poster?
    let movieLength: Int?
    let premiere: Premiere?
    let genres: [Genre]?
    let type: String?
    let rating: Rating?
    let description: String?
    let shortDescription: String?
    let name: String?
    let enName: String?

    // MARK: Poster
    struct Poster: Decodable {
        let url: String
        let previewUrl: String
    }

    // MARK: Premiere
    struct Premiere: Decodable {
        let world: String
    }

    // MARK: Genre
    struct Genre: Decodable {
        let name: String
    }

    // MARK: Rating
    struct Rating: Decodable {
        let kp: Double
    }
}
