//
//  MovieDTO.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

// MARK: - Movie DTO
struct Movie {
    let id: Int
    let poster: Poster
    let movieLength: Int
    let premiere: Premiere
    let genres: [Genre]
    let type: String
    let rating: Rating
    let description: String
    let shortDescription: String
    let name: String
    let enName: String
    let persons: [Person]
    var isFavorite: Bool
    var isRecent: Bool
    
    // MARK: Poster
    struct Poster {
        let url: String
        let previewUrl: String
    }

    // MARK: Premiere
    struct Premiere {
        let world: String
    }

    // MARK: Genre
    struct Genre {
        let name: String
    }

    // MARK: Rating
    struct Rating {
        let value: Double
        let votesCount: Int
    }

    // MARK: Person
    struct Person {
        let id: Int
        let photo: String
        let name: String
        let enName: String
        let profession: String
        let enProfession: String
    }
}
