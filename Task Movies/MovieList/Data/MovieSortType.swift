//
//  MovieSortType.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

enum MovieSortType: String {

    case ratingAscending = "vote_average.asc"
    case ratingDescending = "vote_average.desc"
    case popularityAscending = "popularity.asc"
    case popularityDescending =  "popularity.desc"
    case revenueDescending = "revenue.desc"
    case revenueAscending =  "revenue.asc"
}
