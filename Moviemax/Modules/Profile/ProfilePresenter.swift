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
    
    // Форматтеры дат
    private lazy var displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    private lazy var storageFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(router: ProfileRouter, dependency: DI) {
        self.router = router
        self.userService = dependency.userService
    }
    
    func formatDateForDisplay(_ date: Date) -> String {
        displayFormatter.string(from: date)
    }
    
    func backButtonTapped() {
        router.navigateToBack()
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
            birthDate: formatDateForDisplay(currentUser.birthDate),
            gender: currentUser.gender,
            notes: currentUser.notes ?? ""
        )
        
        // Устанавливаем аватар пользователя если есть
        if let avatarData = currentUser.avatar {
            view?.setupUserAvatar(data: avatarData)
        }
    }
    
    func saveUserProfile(
        firstName: String,
        lastName: String,
        email: String,
        birthDate: String,
        gender: User.Gender,
        notes: String,
        avatarData: Data?
    ) {
        guard let currentUser = userService.getCurrentUser() else {
            view?.showAlert(title: Constants.errorTitle, message: Constants.userNotAuthenticatedError)
            return
        }
        
        // Создаем обновленную модель пользователя
        var updatedUser = currentUser
        updatedUser.firstName = firstName
        updatedUser.lastName = lastName
        updatedUser.email = email
        updatedUser.birthDate = formatDateForStorage(birthDate)
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
    
    func showEditPhotoView() {
        view?.showEditPhotoView()
    }
}

// MARK: - Private Methods
private extension ProfilePresenter {
    func formatDateForStorage(_ displayDateString: String) -> String {
        if let date = displayFormatter.date(from: displayDateString) {
            return storageFormatter.string(from: date)
        }
        
        return displayDateString
    }
    
    func formatDateForDisplay(_ dateString: String) -> String {
        if dateString.isEmpty { return "" }
        
        if let date = storageFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }
        
        return dateString
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
