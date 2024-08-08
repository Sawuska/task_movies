//
//  MovieDetails.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation

struct MovieDetails: Decodable {

    let title: String?
    let releaseDate: String?
    let voteAverage: Double?
    let posterPath: String?
    let genres: [Genre]?
    let originCountry: [String]
    let overview: String?
}
