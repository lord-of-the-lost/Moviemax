//
//  DI.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

final class DI {
    lazy var networkService = NetworkService()
    lazy var authorizationService = AuthorizationService()
}
