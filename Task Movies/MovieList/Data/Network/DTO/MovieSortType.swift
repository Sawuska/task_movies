//
//  MovieSortType.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

enum MovieSortType: String, CaseIterable {

    case popularityDescending =  "popularity.desc"
    case popularityAscending = "popularity.asc"
    case ratingDescending = "vote_average.desc"
    case ratingAscending = "vote_average.asc"
    case revenueDescending = "revenue.desc"
    case revenueAscending =  "revenue.asc"
}
