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
            descriptionText: "Sam Greenfield, an orphaned young woman with a life plagued by misfortune, is forced out from her foster home, much to the dismay of her younger friend and roommate Hazel, who is hoping to be adopted soon. One night, after sharing food with a black cat, Sam finds a penny she hopes to give to Hazel for her collection of lucky items that may help her get adopted. The next day, Sam notices that the penny has made her luck improve. However, she loses the penny by inadvertently flushing it down a toilet. While bemoaning her error, Sam encounters the cat again and says what happened, which causes the cat to berate her for losing the penny. Shocked that the cat could talk, Sam follows the cat through a portal to the Land of Luck, where creatures like leprechauns create good luck for the people on Earth. The cat, named Bob, needs the penny for traveling purposes and will be banished if word gets out that he lost it. Bob and Sam make a deal to get another penny from the Penny depot for Hazel to use before returning it to Bob. Bob uses a button from Sam to pass off as a penny while she sneaks into the Land of Luck using clothes belonging to Bob's personal leprechaun, Gerry. Throughout the journey, Sam comes to learn that bad luck is managed underneath the Land of Luck."
        )
        let viewController = MovieDetailViewController(presenter: presenter, model: model)
        
        router.viewController = viewController
        return viewController
    }
}
