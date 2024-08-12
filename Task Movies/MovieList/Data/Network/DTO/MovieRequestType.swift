//
//  MovieRequestType.swift
//  Task Movies
//
//  Created by Alexandra on 08.08.2024.
//

import Foundation

enum MovieRequestType: Equatable {

    case discover(sort: MovieSortType)
    case search(query: String)

    var description: String {
        switch self {
        case .discover(let sort):
            return sort.rawValue
        case .search(let query):
            return "query_" + query
        }
    }
}
