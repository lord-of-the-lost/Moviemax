//
//  UserService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 05.04.2025.
//

import Foundation

enum UserError: Error {
    case notLoggedIn
    case userNotFound
    case updateFailed
}

final class UserService {
    private let coreDataManager: CoreDataManager
    private let authService: AuthenticationService
    
    init(coreDataManager: CoreDataManager, authService: AuthenticationService) {
        self.coreDataManager = coreDataManager
        self.authService = authService
    }
    
    func getCurrentUser() -> User? {
        authService.getCurrentUser()
    }
    
    func updateUserProfile(user: User) -> Result<User, UserError> {
        guard let currentUser = authService.getCurrentUser() else {
            return .failure(.notLoggedIn)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.userNotFound)
        }
        
        coreDataManager.updateUser(userEntity, with: user)
        let updatedUser = coreDataManager.convertToUser(userEntity)
        
        var appState = coreDataManager.getAppStateModel()
        appState.currentUser = updatedUser
        coreDataManager.updateAppState(with: appState)
        
        return .success(updatedUser)
    }
    
    func completeOnboarding() -> Result<User, UserError> {
        guard let currentUser = authService.getCurrentUser() else {
            return .failure(.notLoggedIn)
        }
        
        guard let userEntity = coreDataManager.getUser(by: currentUser.email) else {
            return .failure(.userNotFound)
        }
        
        var updatedUser = currentUser
        updatedUser.isOnboardingCompleted = true
        
        coreDataManager.updateUser(userEntity, with: updatedUser)
        let result = coreDataManager.convertToUser(userEntity)
        
        var appState = coreDataManager.getAppStateModel()
        appState.currentUser = result
        coreDataManager.updateAppState(with: appState)
        
        return .success(result)
    }
}
