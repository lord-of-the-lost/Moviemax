//
//  HomeViewModel.swift
//  Moviemax
//
//  Created by Николай Игнатов on 11.04.2025.
//

import UIKit

struct HomeViewModel {
    // Модель данных для заголовка с приветствием пользователя
    let userHeader: UserHeaderView.UserHeaderViewModel
    
    // Модель данных для карусели фильмов
    let sliderMovies: [MovieSliderView.MovieViewModel]
    
    // Категории фильмов (жанры)
    let categories: [String]
    
    // Фильмы для раздела Box Office
    let boxOfficeMovies: [MovieSmallCell.MovieSmallCellViewModel]
} 
