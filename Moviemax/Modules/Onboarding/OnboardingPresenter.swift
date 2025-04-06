//
//  OnboardingPresenter.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

import UIKit

final class OnboardingPresenter {
    weak var view: OnboardingViewController?
    private let router: OnboardingRouter
    private let dependency: DI

    private var currentPageIndex: Int = 0
    private var pageModels: [PageModel] = [
        PageModel(id: 0,
                  image: .page1,
                  largeTitle: Constants.Text.largeTitlePage1,
                  text: Constants.Text.descriptionPage1,
                  buttinTitle: Constants.Text.buttonTitlePage1
                 ),
        PageModel(id: 1,
                  image: .page2,
                  largeTitle: Constants.Text.largeTitlePage2,
                  text: Constants.Text.descriptionPage2,
                  buttinTitle: Constants.Text.buttonTitlePage2
                 ),
        PageModel(id: 2,
                  image: .page3,
                  largeTitle: Constants.Text.largeTitlePage3,
                  text: Constants.Text.descriptionPage3,
                  buttinTitle: Constants.Text.buttonTitlePage3
                 )
    ]
    
    init(router: OnboardingRouter, dependency: DI) {
        self.router = router
        self.dependency = dependency
    }
    
    func viewDidLoad() {
        view?.updateView(with: pageModels[currentPageIndex])
    }

    // TODO: Это для тестирования. Переделать когда онбординг будет сохраняться.
    func nextButtonTapped() {
        currentPageIndex += 1
        guard let model = pageModels[safe: currentPageIndex] else {
            if currentPageIndex > 2 {
                view?.showAlert(
                    title: "Навигация",
                    message: "Перейти на экран авторизации?",
                    actionHandler: { [weak self] action in
                        if action.style == .default {
                            self?.router.navigateToAuth()
                        } else if action.style == .cancel {
                            self?.currentPageIndex = 0
                            self?.view?.updateView(with: (self?.pageModels[0])!)
                        }
                    })
            }
            return
        }
        view?.updateView(with: model)
    }
}


// MARK: - Constants
private extension OnboardingPresenter {
    enum Constants {
        enum Text {
            static let largeTitlePage1: String = "Your Pocket Cinema"
            static let largeTitlePage2: String = "Create Your Watchlist"
            static let largeTitlePage3: String = "Watch your favorite movie easily"

            static let descriptionPage1: String = "Stream movies, shows, cartoons, and documentaries anytime, anywhere — all eyes on the screen!"
            static let descriptionPage2: String = "Save your favorites and get personalized recommendations to find your next favorite show."
            static let descriptionPage3: String = "Browse a vast library of films and series from various genres and languages."
           
            static let buttonTitlePage1: String = "Continue"
            static let buttonTitlePage2: String = "Continue"
            static let buttonTitlePage3: String = "Start"

        }
    }
}
