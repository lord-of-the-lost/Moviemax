//
//  CoreDataManager.swift
//  Moviemax
//
//  Created by Николай Игнатов on 04.04.2025.
//


import CoreData

final class CoreDataManager {
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - User Methods
    func createUser(from user: User) -> UserEntity {
        let userEntity = UserEntity(context: context)
        updateUserEntity(userEntity, from: user)
        saveContext()
        return userEntity
    }
    
    func updateUserEntity(_ entity: UserEntity, from user: User) {
        entity.id = user.id
        entity.firstName = user.firstName
        entity.lastName = user.lastName
        entity.email = user.email
        entity.password = user.password
        entity.birthDate = user.birthDate
        entity.gender = user.gender.rawValue
        entity.notes = user.notes
        entity.avatar = user.avatar
        entity.isOnboardingCompleted = user.isOnboardingCompleted
    }
    
    func getUser(by email: String) -> UserEntity? {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        return try? context.fetch(request).first
    }
    
    func updateUser(_ entity: UserEntity, with user: User) {
        updateUserEntity(entity, from: user)
        saveContext()
    }
    
    func convertToUser(_ entity: UserEntity) -> User {
        User(
            id: entity.id,
            firstName: entity.firstName,
            lastName: entity.lastName,
            avatar: entity.avatar,
            email: entity.email,
            password: entity.password,
            birthDate: entity.birthDate,
            gender: User.Gender(rawValue: entity.gender) ?? .male,
            notes: entity.notes,
            recentWatch: convertToMovies(Array(entity.recentWatch)),
            favorites: convertToMovies(Array(entity.favorites)),
            isOnboardingCompleted: entity.isOnboardingCompleted
        )
    }
    
    // MARK: - AppState Methods
    func getAppState() -> AppStateEntity {
        let request = AppStateEntity.fetchRequest()
        if let appState = try? context.fetch(request).first {
            return appState
        }
        
        let appState = AppStateEntity(context: context)
        appState.currentTheme = AppTheme.light.rawValue
        appState.currentLanguage = AppLanguage.english.rawValue
        saveContext()
        return appState
    }
    
    func updateAppState(with state: AppState) {
        let appStateEntity = getAppState()
        appStateEntity.currentTheme = state.currentTheme.rawValue
        appStateEntity.currentLanguage = state.currentLanguage.rawValue
        
        if let currentUser = state.currentUser {
            let userEntity = getUser(by: currentUser.email) ?? createUser(from: currentUser)
            appStateEntity.currentUser = userEntity
        } else {
            appStateEntity.currentUser = nil
        }
        
        saveContext()
    }
    
    func getAppStateModel() -> AppState {
        let entity = getAppState()
        return AppState(
            currentTheme: AppTheme(rawValue: entity.currentTheme) ?? .light,
            currentLanguage: AppLanguage(rawValue: entity.currentLanguage) ?? .english,
            users: entity.users.map { convertToUser($0) },
            currentUser: entity.currentUser.map { convertToUser($0) }
        )
    }
    
    // MARK: - Movie Methods
    func createMovie(from movie: Movie) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        updateMovieEntity(movieEntity, from: movie)
        saveContext()
        return movieEntity
    }
    
    func updateMovieEntity(_ entity: MovieEntity, from movie: Movie) {
        entity.id = Int(movie.id)
        entity.name = movie.name
        entity.enName = movie.enName
        entity.posterUrl = movie.poster.url
        entity.posterPreviewUrl = movie.poster.previewUrl
        entity.movieLength = Int(movie.movieLength)
        entity.premiereWorld = movie.premiere.world
        entity.type = movie.type
        entity.ratingValue = movie.rating.value
        entity.ratingVotesCount = Int(movie.rating.votesCount)
        entity.movieDescription = movie.description
        entity.smallDescription = movie.shortDescription
        entity.trailerURL = movie.trailerURL
        entity.isFavorite = movie.isFavorite
        entity.isRecent = movie.isRecent
        
        // Обработка жанров
        let genres = movie.genres.map { genre -> GenreEntity in
            let request = GenreEntity.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", genre.name)
            if let existingGenre = try? context.fetch(request).first {
                return existingGenre
            } else {
                let genreEntity = GenreEntity(context: context)
                genreEntity.name = genre.name
                return genreEntity
            }
        }
        entity.genres = Set(genres)
        
        // Обработка персон
        let persons = movie.persons.map { person -> PersonEntity in
            let request = PersonEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", person.id)
            if let existingPerson = try? context.fetch(request).first {
                return existingPerson
            } else {
                let personEntity = PersonEntity(context: context)
                personEntity.id = Int(person.id)
                personEntity.name = person.name
                personEntity.enName = person.enName
                personEntity.photo = person.photo
                personEntity.profession = person.profession
                personEntity.enProfession = person.enProfession
                return personEntity
            }
        }
        entity.persons = Set(persons)
    }
    
    func getMovie(by id: Int) -> MovieEntity? {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return try? context.fetch(request).first
    }
    
    func updateMovie(_ entity: MovieEntity, with movie: Movie) {
        updateMovieEntity(entity, from: movie)
        saveContext()
    }
    
    func convertToMovie(_ entity: MovieEntity) -> Movie {
        Movie(
            id: entity.id,
            poster: Movie.Poster(
                url: entity.posterUrl,
                previewUrl: entity.posterPreviewUrl
            ),
            movieLength: entity.movieLength,
            premiere: Movie.Premiere(
                world: entity.premiereWorld
            ),
            genres: entity.genres.map { Movie.Genre(name: $0.name) },
            type: entity.type,
            rating: Movie.Rating(
                value: entity.ratingValue,
                votesCount: entity.ratingVotesCount
            ),
            description: entity.movieDescription,
            shortDescription: entity.smallDescription,
            name: entity.name,
            enName: entity.enName,
            persons: entity.persons.map {
                Movie.Person(
                    id: $0.id,
                    photo: $0.photo,
                    name: $0.name,
                    enName: $0.enName,
                    profession: $0.profession,
                    enProfession: $0.enProfession
                )
            },
            trailerURL: entity.trailerURL,
            isFavorite: entity.isFavorite,
            isRecent: entity.isRecent
        )
    }
    
    func convertToMovies(_ entities: [MovieEntity]) -> [Movie] {
        entities.map { convertToMovie($0) }
    }
    
    // MARK: - Favorites & Recent
    func toggleFavorite(movieId: Int, for userEmail: String) {
        guard let user = getUser(by: userEmail),
              let movie = getMovie(by: movieId) else { return }
        
        if user.favorites.contains(movie) {
            user.favorites.remove(movie)
        } else {
            user.favorites.insert(movie)
        }
        saveContext()
    }
    
    func addToRecentlyWatched(movieId: Int, for userEmail: String) {
        guard let user = getUser(by: userEmail),
              let movie = getMovie(by: movieId) else { return }
        
        user.recentWatch.insert(movie)
        saveContext()
    }
    
    // MARK: - Helper Methods
    func clearAllRecentlyWatched(for userEmail: String) {
        guard let user = getUser(by: userEmail) else { return }
        user.recentWatch.removeAll()
        saveContext()
    }
    
    func clearAllFavorites(for userEmail: String) {
        guard let user = getUser(by: userEmail) else { return }
        user.favorites.removeAll()
        saveContext()
    }
}
