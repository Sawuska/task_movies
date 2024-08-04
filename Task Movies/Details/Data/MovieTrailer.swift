//
//  MovieTrailer.swift
//  Task Movies
//
//  Created by Alexandra on 04.08.2024.
//

import Foundation

struct MovieTrailer: Decodable {

    let site: String
    let key: String
    let official: Bool
    let type: String
}
