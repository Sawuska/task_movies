//
//  Movie.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

struct Movie: Decodable {

    let title: String
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String
    let genreIds: [Int]
}
