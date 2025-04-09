//
//  ProfilePresenter.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import Foundation

final class ProfilePresenter {
    weak var view: ProfileViewController?
    private let router: ProfileRouter
    private let userService: UserService
    
    init(router: ProfileRouter, dependency: DI) {
        self.router = router
        self.userService = dependency.userService
    }
    
    func loadUserProfile() {
        guard let currentUser = userService.getCurrentUser() else {
            assertionFailure("User not found")
            return
        }
        
        // Отображаем данные пользователя
        view?.updateUserData(
            firstName: currentUser.firstName,
            lastName: currentUser.lastName,
            email: currentUser.email,
            birthDate: currentUser.birthDate,
            gender: currentUser.gender,
            notes: currentUser.notes ?? ""
        )
        
        // Устанавливаем аватар пользователя если есть
        if let avatarData = currentUser.avatar {
            view?.updateUserAvatar(data: avatarData)
        }
    }
    
    func saveUserProfile(firstName: String, lastName: String, email: String, birthDate: String, gender: User.Gender, notes: String, avatarData: Data?) {
        guard let currentUser = userService.getCurrentUser() else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.userNotAuthenticatedError)
            return
        }
        
        // Создаем обновленную модель пользователя
        var updatedUser = currentUser
        updatedUser.firstName = firstName
        updatedUser.lastName = lastName
        updatedUser.email = email
        updatedUser.birthDate = birthDate
        updatedUser.gender = gender
        updatedUser.notes = notes.isEmpty ? nil : notes
        
        // Обновляем аватар только если он был изменен
        if let newAvatarData = avatarData {
            updatedUser.avatar = newAvatarData
        }
        
        // Сохраняем обновленные данные
        let result = userService.updateUserProfile(user: updatedUser)
        
        switch result {
        case .success:
            view?.showAlert(title: Constants.successTitle, message: Constants.profileUpdatedSuccess)
        case .failure:
            view?.showAlert(title: Constants.errorTitle, message: Constants.profileUpdateError)
        }
    }
}

// MARK: - Constants
private extension ProfilePresenter {
    enum Constants {
        static let errorTitle = "Ошибка"
        static let successTitle = "Успех"
        static let userNotAuthenticatedError = "Пользователь не авторизован"
        static let profileUpdateError = "Не удалось обновить профиль"
        static let profileUpdatedSuccess = "Профиль успешно обновлен"
    }
}
