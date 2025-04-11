//
//  DI.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

final class DI {
    lazy var coreDataManager = CoreDataManager()
    lazy var imageCacheService = ImageCacheService()
    lazy var networkService = NetworkService(imageCacheService: imageCacheService)
    lazy var localizationManager = LocalizationManager(coreDataManager: coreDataManager)
    lazy var themeManager = ThemeManager(coreDataManager: coreDataManager)
    lazy var authService = AuthenticationService(coreDataManager: coreDataManager)
    lazy var userService = UserService(
        coreDataManager: coreDataManager,
        authService: authService
    )
    lazy var movieRepository = MovieRepository(
        coreDataManager: coreDataManager,
        networkService: networkService,
        userService: userService
    )
}
