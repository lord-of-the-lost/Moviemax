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
            largeTitle: TextConstants.Onboarding.FirstPage.largeTitle.localized(),
            text: TextConstants.Onboarding.FirstPage.description.localized(),
            buttonTitle: TextConstants.Onboarding.FirstPage.buttonTitle.localized()
        ),
        PageModel(
            id: 1,
            image: .page2,
            largeTitle: TextConstants.Onboarding.SecontPage.largeTitle.localized(),
            text: TextConstants.Onboarding.SecontPage.description.localized(),
            buttonTitle: TextConstants.Onboarding.SecontPage.buttonTitle.localized()
        ),
        PageModel(
            id: 2,
            image: .page3,
            largeTitle: TextConstants.Onboarding.ThirdPage.largeTitle.localized(),
            text: TextConstants.Onboarding.ThirdPage.description.localized(),
            buttonTitle: TextConstants.Onboarding.ThirdPage.buttonTitle.localized()
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
    
    func prevButtonTapped() {
        currentPageIndex -= 1
        guard let model = pageModels[safe: currentPageIndex] else {
            if currentPageIndex > 2 {
                router.navigateToAuth()
            }
            return
        }
        view?.updateView(with: model)
    }
}
