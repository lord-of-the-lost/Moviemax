//
//  HomeViewModel.swift
//  Moviemax
//
//  Created by Николай Игнатов on 11.04.2025.
//

import UIKit

struct HomeViewModel {
    // Модель данных для заголовка с приветствием пользователя
    var userHeader: UserHeaderView.UserHeaderViewModel
    
    // Модель данных для карусели фильмов
    var sliderMovies: [PosterCell.PosterCellViewModel]
    
    // Категории фильмов (жанры)
    var categories: [String]
    
    // Фильмы для раздела Box Office
    var boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel]
} 
