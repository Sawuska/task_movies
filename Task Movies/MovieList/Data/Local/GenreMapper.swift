//
//  GenreMapper.swift
//  Task Movies
//
//  Created by Alexandra on 02.08.2024.
//

import Foundation

final class GenreMapper {

    func mapToString(ids: [Int], from genres: [Genre]) -> String {
        let genreNames = genres.filter { ids.contains($0.id) }.map { $0.name }
        return ListFormatter.localizedString(byJoining: genreNames)
    }
}
