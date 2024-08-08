//
//  MovieDetailsUIMapper.swift
//  Task Movies
//
//  Created by Alexandra on 03.08.2024.
//

import Foundation

final class MovieDetailsUIMapper {

    func mapDetailsToUI(details: MovieDetails?, trailer: MovieTrailer?, genreMapper: GenreMapper) -> MovieDetailsUIModel {
        let year = details?.releaseDate?.prefix(4) ?? ""
        let countries = ListFormatter.localizedString(byJoining: details?.originCountry ?? [])
        let separator = !countries.isEmpty && !year.isEmpty ? ", " : ""
        let countryAndYear = countries + separator + year
        let rating = details?.voteAverage.map { String(localized: "Rating: ") + String($0) } ?? ""
        let genres = genreMapper.mapGenresToString(genres: details?.genres ?? [])
        let posterURL = details?.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500" + $0) }
        let shouldEnableImageInteraction = posterURL != nil
        let trailerURL = trailer.flatMap { URL(string: "https://youtube.com/embed/" + $0.key) }
        let shouldHideTrailerButton = trailerURL == nil
        return MovieDetailsUIModel(
            title: details?.title ?? "",
            countryAndYear: countryAndYear,
            rating: rating,
            overview: details?.overview ?? "",
            genres: genres,
            shouldEnableImageInteraction: shouldEnableImageInteraction,
            posterURL: posterURL,
            shouldHideTrailerButton: shouldHideTrailerButton,
            trailerURL: trailerURL
        )
    }
}
