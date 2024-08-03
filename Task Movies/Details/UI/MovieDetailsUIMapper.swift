//
//  MovieDetailsUIMapper.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation

final class MovieDetailsUIMapper {

    func mapDetailsToUI(details: MovieDetails?, genreMapper: GenreMapper) -> MovieDetailsUIModel {
        let year = details?.releaseDate.prefix(4) ?? ""
        let countries = ListFormatter.localizedString(byJoining: details?.originCountry ?? [])
        let countryAndYear = countries + ", " + year
        let rating = details.map { "Rating: " + String($0.voteAverage) } ?? ""
        let genres = genreMapper.mapGenresToString(genres: details?.genres ?? [])
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (details?.posterPath ?? ""))
        return MovieDetailsUIModel(
            title: details?.title ?? "",
            countryAndYear: countryAndYear,
            rating: rating,
            overview: details?.overview ?? "",
            genres: genres,
            posterURL: posterURL)
    }
}
