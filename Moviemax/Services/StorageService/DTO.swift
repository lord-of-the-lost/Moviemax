//
//  DTO.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//

import Foundation

// MARK: - AppTheme
enum AppTheme: String {
    case light
    case dark
}

// MARK: - AppLanguage
enum AppLanguage: String {
    case russian
    case english
}

// MARK: - AppState
struct AppState {
    var currentTheme: AppTheme
    var currentLanguage: AppLanguage
    var users: [User]
    var currentUser: User?
}

// MARK: - User
struct User {
    let id: UUID
    var firstName: String
    var lastName: String
    var avatar: Data?
    var email: String
    var password: String
    var birthDate: String
    var gender: Gender
    var notes: String?
    var recentWatch: [Movie]
    var favorites: [Movie]
    var isOnboardingCompleted: Bool
    
    // MARK: Gender
    enum Gender: String {
        case male = "Male"
        case female = "Female"
        
        var description: String {
            switch self {
            case .male:
                return TextConstants.Gender.male.localized()
            case .female:
                return TextConstants.Gender.female.localized()
            }
        }
    }
}

// MARK: - Movie
struct Movie {
    let id: Int
    var poster: Poster
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
    let trailerURL: String
    var isFavorite: Bool
    var isRecent: Bool
    
    // MARK: Poster
    struct Poster {
        var url: String
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
