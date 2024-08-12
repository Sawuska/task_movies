//
//  MovieUIMapper.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

final class MovieUIMapper {

    func mapEntitiesToUI(movies: [MovieEntity]) -> [MovieUIModel] {
        movies.map { entity in
            let year = entity.releaseDate?.prefix(4) ??
            String.SubSequence(stringLiteral: String(localized: "year"))
            let titleAndYear = (entity.title ?? String(localized: "Title")) + ", " + year
            let rating = String(entity.rating)
            let genres = entity.genres ?? ""
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (entity.posterPath ?? ""))
            return MovieUIModel(
                id: Int(entity.id),
                titleAndYear: titleAndYear,
                rating: rating,
                genres: genres,
                posterURL: posterURL)
        }
    }
}
