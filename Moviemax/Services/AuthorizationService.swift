//
//  AuthorizationService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

final class AuthorizationService {
    var isAuthorized: Bool = false
    
    func login() {
        isAuthorized = true
    }
    
    func logout() {
        isAuthorized = false
    }
}
