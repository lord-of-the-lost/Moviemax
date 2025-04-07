//
//  MovieDetailFactory.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

enum MovieDetailFactory {
    static func build(_ dependency: DI) -> MovieDetailViewController {
        let router = MovieDetailRouter(dependency: dependency)
        let presenter = MovieDetailPresenter(router: router, dependency: dependency)
        let model: MovieDetailModel = .init(
            title: "Luck",
            image: "",
            duration: "148 Minutes",
            date: "17 Sep 2021",
            genre: "Action",
            descriptionTitle: "Story Line",
            descriptionText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
        )
        let viewController = MovieDetailViewController(presenter: presenter, model: model)
        
        router.viewController = viewController
        return viewController
    }
}
