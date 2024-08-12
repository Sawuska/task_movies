//
//  GenreMapper.swift
//  Task Movies
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation

final class GenreMapper {

    func mapToString(ids: [Int], from genres: [Genre]) -> String {
        let movieGenres = genres.filter { ids.contains($0.id) }
        return mapGenresToString(genres: movieGenres)
    }

    func mapGenresToString(genres: [Genre]) -> String {
        let genreNames = genres.map { $0.name }
        return ListFormatter.localizedString(byJoining: genreNames)
    }
}
