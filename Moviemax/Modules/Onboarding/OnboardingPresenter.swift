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
        PageModel(
            id: 0,
            image: .page1,
            largeTitle: Constants.Text.FirstPage.largeTitle,
            text: Constants.Text.FirstPage.description,
            buttonTitle: Constants.Text.FirstPage.buttonTitle
        ),
        PageModel(
            id: 1,
            image: .page2,
            largeTitle: Constants.Text.SecontPage.largeTitle,
            text: Constants.Text.SecontPage.description,
            buttonTitle: Constants.Text.SecontPage.buttonTitle
        ),
        PageModel(
            id: 2,
            image: .page3,
            largeTitle: Constants.Text.ThirdPage.largeTitle,
            text: Constants.Text.ThirdPage.description,
            buttonTitle: Constants.Text.ThirdPage.buttonTitle
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
                router.navigateToAuth()
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
            enum FirstPage {
                static let largeTitle: String = "Your Pocket Cinema"
                static let description: String = "Stream movies, shows, cartoons, and documentaries anytime, anywhere — all eyes on the screen!"
                static let buttonTitle: String = "Continue"
            }
            
            enum SecontPage {
                static let largeTitle: String = "Create Your Watchlist"
                static let description: String = "Save your favorites and get personalized recommendations to find your next favorite show."
                static let buttonTitle: String = "Continue"
            }
            
            enum ThirdPage {
                static let largeTitle: String = "Watch your favorite movie easily"
                static let description: String = "Browse a vast library of films and series from various genres and languages."
                static let buttonTitle: String = "Start"
            }
        }
    }
}
