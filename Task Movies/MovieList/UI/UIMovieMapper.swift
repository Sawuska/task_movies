//
//  UIMovieMapper.swift
//  Task Movies
//
//  Created by Alexandra on 01.08.2024.
//

import Foundation

final class UIMovieMapper {
    
    func mapToUI(movies: [Movie]) -> [MovieUIModel] {
        movies.map { movie in
            let year = movie.releaseDate.prefix(4)
            let titleAndYear = movie.title + ", " + year
            let rating = String(movie.voteAverage)
            let genres = movie.genreIds.map { String($0) }.joined(separator: ", ")
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + movie.posterPath)
            return MovieUIModel(
                titleAndYear: titleAndYear,
                rating: rating,
                genres: genres,
                posterURL: posterURL
            )
        }
    }
}
