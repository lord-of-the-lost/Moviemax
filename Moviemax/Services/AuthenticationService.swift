//
//  AuthenticationService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

enum AuthError: Error {
    case userNotFound
    case invalidPassword
    case emailAlreadyExists
    case unknown
}

final class AuthenticationService {
    private let coreDataManager: CoreDataManager
    private var shouldRememberUser: Bool = true
    
    var isAuthorized: Bool {
        coreDataManager.getAppStateModel().currentUser != nil
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func login(email: String, password: String, rememberMe: Bool = true) -> Result<User, AuthError> {
        guard let userEntity = coreDataManager.getUser(by: email) else {
            return .failure(.userNotFound)
        }
        
        guard userEntity.password == password else {
            return .failure(.invalidPassword)
        }
        
        shouldRememberUser = rememberMe
        
        let user = coreDataManager.convertToUser(userEntity)
        var appState = coreDataManager.getAppStateModel()
        appState.currentUser = user
        coreDataManager.updateAppState(with: appState)
        
        return .success(user)
    }
    
    func register(user: User) -> Result<User, AuthError> {
        if coreDataManager.getUser(by: user.email) != nil {
            return .failure(.emailAlreadyExists)
        }
        
        let userEntity = coreDataManager.createUser(from: user)
        let newUser = coreDataManager.convertToUser(userEntity)
        
        var appState = coreDataManager.getAppStateModel()
        appState.currentUser = newUser
        coreDataManager.updateAppState(with: appState)
        
        return .success(newUser)
    }
    
    func logout() {
        var appState = coreDataManager.getAppStateModel()
        appState.currentUser = nil
        coreDataManager.updateAppState(with: appState)
    }
    
    func getCurrentUser() -> User? {
        coreDataManager.getAppStateModel().currentUser
    }
    
    func shouldAutoLogout() -> Bool {
        return !shouldRememberUser
    }
    
    func getUserByEmail(email: String) -> UserEntity? {
        coreDataManager.getUser(by: email)
    }
}
