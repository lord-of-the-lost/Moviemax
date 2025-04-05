//
//  AppStateEntity.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//


import CoreData

@objc(AppStateEntity)
public class AppStateEntity: NSManagedObject {
    @NSManaged public var currentTheme: String
    @NSManaged public var currentLanguage: String
    @NSManaged public var users: Set<UserEntity>
    @NSManaged public var currentUser: UserEntity?
}

extension AppStateEntity {
    static func fetchRequest() -> NSFetchRequest<AppStateEntity> {
        NSFetchRequest<AppStateEntity>(entityName: "AppStateEntity")
    }
}

@objc(UserEntity)
public class UserEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var avatar: Data?
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var birthDate: String
    @NSManaged public var gender: String
    @NSManaged public var notes: String?
    @NSManaged public var recentWatch: Set<MovieEntity>
    @NSManaged public var favorites: Set<MovieEntity>
    @NSManaged public var isOnboardingCompleted: Bool
    @NSManaged public var appState: AppStateEntity?
    @NSManaged public var appStateAsCurrentUser: AppStateEntity?
}

extension UserEntity {
    static func fetchRequest() -> NSFetchRequest<UserEntity> {
        NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }
}

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var posterUrl: String
    @NSManaged public var posterPreviewUrl: String
    @NSManaged public var movieLength: Int
    @NSManaged public var premiereWorld: String
    @NSManaged public var genres: Set<GenreEntity>
    @NSManaged public var type: String
    @NSManaged public var ratingValue: Double
    @NSManaged public var ratingVotesCount: Int
    @NSManaged public var movieDescription: String
    @NSManaged public var smallDescription: String
    @NSManaged public var name: String
    @NSManaged public var enName: String
    @NSManaged public var persons: Set<PersonEntity>
    @NSManaged public var trailerURL: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isRecent: Bool
    @NSManaged public var favoriteByUsers: Set<UserEntity>
    @NSManaged public var recentWatchByUsers: Set<UserEntity>
}

extension MovieEntity {
    static func fetchRequest() -> NSFetchRequest<MovieEntity> {
        NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }
}

@objc(GenreEntity)
public class GenreEntity: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var movies: Set<MovieEntity>
}

extension GenreEntity {
    static func fetchRequest() -> NSFetchRequest<GenreEntity> {
        NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }
}

@objc(PersonEntity)
public class PersonEntity: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var photo: String
    @NSManaged public var name: String
    @NSManaged public var enName: String
    @NSManaged public var profession: String
    @NSManaged public var enProfession: String
    @NSManaged public var movies: Set<MovieEntity>
}

extension PersonEntity {
    static func fetchRequest() -> NSFetchRequest<PersonEntity> {
        NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }
}
