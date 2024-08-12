//
//  MovieDetailsUIModel.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation

struct  MovieDetailsUIModel {
    
    let title: String
    let countryAndYear: String
    let rating: String
    let overview: String
    let genres: String
    let shouldEnableImageInteraction: Bool
    let posterURL: URL?
    let shouldHideTrailerButton: Bool
    let trailerURL: URL?
}
