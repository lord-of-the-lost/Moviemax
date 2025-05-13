//
//  MovieDetailModel.swift
//  Moviemax
//
//  Created by Penkov Alexander on 05.04.2025.
//

import UIKit

struct MovieDetailModel {
    let title: String
    let image: UIImage
    let duration: String
    let date: String
    let genre: String
    let rating: Double
    let descriptionText: String
    var isFavorite: Bool
    let persons: [Movie.Person]?
}
