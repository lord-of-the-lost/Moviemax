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
    let votes: Votes?
    let description: String?
    let shortDescription: String?
    let name: String?
    let enName: String?
    let persons: [Person]?
    let videos: Videos?
    
    // MARK: Poster
    struct Poster: Decodable {
        let url: String?
        let previewUrl: String?
    }

    // MARK: Premiere
    struct Premiere: Decodable {
        let world: String?
    }

    // MARK: Genre
    struct Genre: Decodable {
        let name: String?
    }

    // MARK: Rating
    struct Rating: Decodable {
        let kp: Double?
    }

    // MARK: Votes
    struct Votes: Decodable {
        let kp: Int?
    }

    // MARK: Person
    struct Person: Decodable {
        let id: Int?
        let photo: String?
        let name: String?
        let enName: String?
        let profession: String?
        let enProfession: String?
    }

    // MARK: Videos
    struct Videos: Decodable {
        let trailers: [Trailer]?
        
        struct Trailer: Decodable {
            let url: String?
        }
    }
}

