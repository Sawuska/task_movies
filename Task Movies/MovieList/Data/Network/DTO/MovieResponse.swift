//
//  MovieResponse.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

struct MovieResponse: Decodable {

    let page: Int
    let results: [Movie]
}
