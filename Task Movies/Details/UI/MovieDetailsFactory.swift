//
//  MovieDetailsFactory.swift
//  Task Movies
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation

final class MovieDetailsFactory {

    private let apiKey: String
    private let language: String

    init(apiKey: String, language: String) {
        self.apiKey = apiKey
        self.language = language
    }

    func create(movieID: Int, router: Router) -> MovieDetailsViewController {
        let repository = DetailsRepository(
            detailsNetworkService: NetworkService<MovieDetails>(
                jsonMapper: JSONMapper<MovieDetails>()),
            videosNetworkService: NetworkService<MovieVideosResponse>(
                jsonMapper: JSONMapper<MovieVideosResponse>()),
            trailerMapper: TrailerMapper(),
            apiKey: apiKey,
            language: language)
        let viewModel = MovieDetailsViewModel(
            repository: repository,
            detailsMapper: MovieDetailsUIMapper(
                genreMapper: GenreMapper()),
            movieID: movieID)
        let vc = MovieDetailsViewController(
            viewModel: viewModel, 
            router: router)
        return vc
    }
}
